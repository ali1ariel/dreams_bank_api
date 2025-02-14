defmodule DreamsBankApi.BankOperations.TransferTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.BankOperations

  describe "transferring money" do
    setup do
      from_account = insert(:account, balance: Decimal.new("2500.00"))
      to_account = insert(:account, balance: Decimal.new("1000.00"))

      %{
        from_account: from_account,
        to_account: to_account
      }
    end

    test "transfer/3 with valid data transfers money between accounts", %{
      from_account: from_account,
      to_account: to_account
    } do
      assert {:ok, %{withdrawal: updated_from, deposit: updated_to}} =
               BankOperations.transfer(from_account, to_account, "500.00")

      assert updated_from.balance == Decimal.new("2000.00")
      assert updated_to.balance == Decimal.new("1500.00")
    end

    test "transfer/3 with insufficient funds returns error", %{
      from_account: from_account,
      to_account: to_account
    } do
      assert {:error, :withdrawal, changeset, _changes} =
               BankOperations.transfer(from_account, to_account, "3000.00")

      assert "must be greater than or equal to 0" in errors_on(changeset).balance
    end

    test "transfer/3 works with different numeric types", %{
      from_account: from_account,
      to_account: to_account
    } do
      assert {:ok, %{withdrawal: from_1, deposit: to_1}} =
               BankOperations.transfer(from_account, to_account, "500.00")

      assert from_1.balance == Decimal.new("2000.00")
      assert to_1.balance == Decimal.new("1500.00")

      assert {:ok, %{withdrawal: from_2, deposit: to_2}} =
               BankOperations.transfer(from_1, to_1, Decimal.new("500.00"))

      assert from_2.balance == Decimal.new("1500.00")
      assert to_2.balance == Decimal.new("2000.00")

      assert {:ok, %{withdrawal: from_3, deposit: to_3}} =
               BankOperations.transfer(from_2, to_2, 500)

      assert from_3.balance == Decimal.new("1000.00")
      assert to_3.balance == Decimal.new("2500.00")
    end
  end
end
