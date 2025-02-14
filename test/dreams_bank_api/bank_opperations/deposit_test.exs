defmodule DreamsBankApi.BankOperations.DepositTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.BankOperations

  describe "depositing money" do
    setup do
      %{account: insert(:account, balance: Decimal.new("2500.00"))}
    end

    test "deposit/1 with valid data deposits money", %{account: account} do
      assert {:ok, account} = BankOperations.deposit(account, Decimal.new("500.00"))
      assert account.balance == Decimal.new("3000.00")
    end

    test "deposit/1 with invalid data returns error", %{account: account} do
      assert {:error, changeset} = BankOperations.deposit(account, "-500.00")
      assert "must be greater than or equal to 0" in errors_on(changeset).deposit
    end

    test "deposit/1 works with string, decimal or integer values", %{account: account} do
      assert {:ok, account} = BankOperations.deposit(account, "500.00")
      assert account.balance == Decimal.new("3000.00")

      assert {:ok, account} = BankOperations.deposit(account, Decimal.new("500.00"))
      assert account.balance == Decimal.new("3500.00")

      assert {:ok, account} = BankOperations.deposit(account, 500)
      assert account.balance == Decimal.new("4000.00")
    end

    test "deposit/1 don't works with float values", %{account: account} do
      assert_raise FunctionClauseError, fn -> BankOperations.deposit(account, 500.50) end
    end
  end
end
