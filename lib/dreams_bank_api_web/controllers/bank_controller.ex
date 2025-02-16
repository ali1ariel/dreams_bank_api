defmodule DreamsBankApiWeb.BankController do
  use DreamsBankApiWeb, :controller

  alias DreamsBankApi.BankService

  def deposit(conn, %{"account_number" => account_number, "amount" => amount}) do
    case choose_node(conn.assigns[:target_node], :deposit, [account_number, amount]) do
      {:ok, account} ->
        conn
        |> put_status(:ok)
        |> render("operation.json", %{account: account, operation: :deposit})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Account not found"})

      {:error, :invalid_amount} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid amount for deposit"})
    end
  end

  def withdrawal(conn, %{"account_number" => account_number, "amount" => amount}) do
    case BankService.withdrawal(account_number, amount) do
      {:ok, account} ->
        conn
        |> put_status(:ok)
        |> render("operation.json", %{account: account, operation: :withdrawal})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Account not found"})

      {:error, :insufficient_funds} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Insufficient funds"})

      {:error, :invalid_amount} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid amount for withdrawal"})
    end
  end

  def transfer(conn, %{
        "from_account" => from_account,
        "to_account" => to_account,
        "amount" => amount
      }) do
    case BankService.transfer(from_account, to_account, amount) do
      {:ok, %{from: from_updated, to: to_updated}} ->
        conn
        |> put_status(:ok)
        |> render("transfer.json", %{from: from_updated, to: to_updated})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "One or both accounts not found"})

      {:error, :same_account} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Cannot transfer to the same account"})

      {:error, :insufficient_funds} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Insufficient funds"})

      {:error, :not_defined} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid amount for transferences"})
    end
  end

  def choose_node(nil, function, params), do: apply(BankService, function, params)

  def choose_node(node, function, params) do
    :rpc.call(node, DreamsBankApi.BankService, function, params)
  end
end
