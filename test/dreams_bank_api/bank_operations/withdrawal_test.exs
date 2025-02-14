defmodule DreamsBankApi.BankOperations.WithdrawalTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.BankOperations

  describe "withdrawing money" do
    setup do
      %{account: insert(:account, balance: Decimal.new("2500.00"))}
    end

    test "withdraw/1 with valid data withdraws money", %{account: account} do
      assert {:ok, account} = BankOperations.withdrawal(account, Decimal.new("500.00"))
      assert account.balance == Decimal.new("2000.00")
    end

    test "withdrawal/1 with invalid data returns error", %{account: account} do
      assert {:error, changeset} = BankOperations.withdrawal(account, "-500.00")
      assert "must be less than or equal to 0" in errors_on(changeset).withdrawal
    end

    test "withdrawal/1 works with string, decimal or integer values", %{account: account} do
      assert {:ok, account} = BankOperations.withdrawal(account, "500.00")
      assert account.balance == Decimal.new("2000.00")

      assert {:ok, account} = BankOperations.withdrawal(account, Decimal.new("500.00"))
      assert account.balance == Decimal.new("1500.00")

      assert {:ok, account} = BankOperations.withdrawal(account, 500)
      assert account.balance == Decimal.new("1000.00")
    end

    test "withdrawal/1 don't works with float values", %{account: account} do
      assert_raise ArgumentError, fn -> BankOperations.withdrawal(account, 500.50) end
    end
  end
end
