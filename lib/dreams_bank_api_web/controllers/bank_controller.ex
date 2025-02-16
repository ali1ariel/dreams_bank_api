defmodule DreamsBankApiWeb.BankController do
  use DreamsBankApiWeb, :controller

  alias DreamsBankApi.BankService

  def deposit(conn, %{"account_number" => account_number, "amount" => amount}) do
    case BankService.deposit(account_number, amount) do
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
end
