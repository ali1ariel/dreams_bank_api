defmodule DreamsBankApiWeb.AccountController do
  use DreamsBankApiWeb, :controller

  alias DreamsBankApi.Accounts

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def create(conn, %{"account" => account_params}) do
    case Accounts.create_account(account_params) do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> render("show.json", account: account)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    case Accounts.update_account(account, account_params) do
      {:ok, account} ->
        render(conn, "show.json", account: account)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    Accounts.delete_account(account)
    send_resp(conn, :no_content, "")
  end

  def show_by_number(conn, %{"number" => number}) do
    account = Accounts.get_account_by_number!(number)
    render(conn, "show.json", account: account)
  end
end
