defmodule DreamsBankApiWeb.BankJSON do
  alias DreamsBankApi.Accounts.Account

  def operation(%{account: account, operation: operation}) do
    %{
      data: %{
        type: Atom.to_string(operation),
        account: account_data(account)
      }
    }
  end

  defp account_data(%Account{} = account) do
    %{
      number: account.number,
      owner: account.owner,
      balance: account.balance
    }
  end
end
