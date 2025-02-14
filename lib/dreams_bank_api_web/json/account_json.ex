defmodule DreamsBankApiWeb.AccountJSON do
  alias DreamsBankApi.Accounts.Account

  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: account(account))}
  end

  def show(%{account: account}) do
    %{data: account(account)}
  end

  defp account(%Account{id: id, owner: name, balance: balance}) do
    %{
      id: id,
      type: "account",
      owner: name,
      balance: balance
    }
  end
end
