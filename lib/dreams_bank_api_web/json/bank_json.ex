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

  def transfer(%{from: from_account, to: to_account}) do
    %{
      data: %{
        type: "transfer",
        from_account: account_data(from_account),
        to_account: account_data(to_account)
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
