defmodule DreamsBankApi.BankService.DepositTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.BankService

  describe "deposit operations" do
    setup do
      account = insert(:account, balance: Decimal.new("1000.00"))
      %{account: account}
    end

    test "deposit/2 successfully adds money to account", %{account: account} do
      assert {:ok, updated_account} = BankService.deposit(account.number, "500.00")
      assert updated_account.balance == Decimal.new("1500.00")
    end

    test "deposit/2 returns error for invalid amount", %{account: account} do
      assert {:error, :invalid_amount} = BankService.deposit(account.number, "-500.00")
    end

    test "deposit/2 returns error for non-existent account" do
      assert {:error, :not_found} = BankService.deposit("0000000-0", "500.00")
    end
  end
end
