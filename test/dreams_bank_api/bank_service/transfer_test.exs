defmodule DreamsBankApi.BankService.TransferTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.BankService

  describe "transfer operations" do
    setup do
      from_account = insert(:account, balance: Decimal.new("1000.00"))
      to_account = insert(:account, balance: Decimal.new("500.00"))

      %{
        from_account: from_account,
        to_account: to_account
      }
    end

    test "transfer/3 successfully transfers money between accounts", %{
      from_account: from_account,
      to_account: to_account
    } do
      assert {:ok, %{from: from_updated, to: to_updated}} =
               BankService.transfer(from_account.number, to_account.number, "500.00")

      assert from_updated.balance == Decimal.new("500.00")
      assert to_updated.balance == Decimal.new("1000.00")
    end

    test "transfer/3 returns error when transferring to same account", %{from_account: account} do
      assert {:error, :same_account} =
               BankService.transfer(account.number, account.number, "500.00")
    end

    test "transfer/3 returns error for insufficient funds", %{
      from_account: from_account,
      to_account: to_account
    } do
      assert {:error, :insufficient_funds} =
               BankService.transfer(from_account.number, to_account.number, "1500.00")
    end

    test "transfer/3 returns error when source account doesn't exist", %{to_account: to_account} do
      assert {:error, :not_found} =
               BankService.transfer("0000000-0", to_account.number, "500.00")
    end

    test "transfer/3 returns error when destination account doesn't exist", %{
      from_account: from_account
    } do
      assert {:error, :not_found} =
               BankService.transfer(from_account.number, "0000000-0", "500.00")
    end
  end
end
