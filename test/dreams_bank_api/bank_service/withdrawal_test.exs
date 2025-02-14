defmodule DreamsBankApi.BankService.WithdrawalTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.BankService

  describe "withdrawal operations" do
    setup do
      account = insert(:account, balance: Decimal.new("1000.00"))
      %{account: account}
    end

    test "withdrawal/2 successfully removes money from account", %{account: account} do
      assert {:ok, updated_account} = BankService.withdrawal(account.number, "500.00")
      assert updated_account.balance == Decimal.new("500.00")
    end

    test "withdrawal/2 returns error for insufficient funds", %{account: account} do
      assert {:error, :insufficient_funds} = BankService.withdrawal(account.number, "1500.00")
    end

    test "withdrawal/2 returns error for invalid amount", %{account: account} do
      assert {:error, :invalid_amount} = BankService.withdrawal(account.number, "-500.00")
    end

    test "withdrawal/2 returns error for non-existent account" do
      assert {:error, :not_found} = BankService.withdrawal("0000000-0", "500.00")
    end
  end
end
