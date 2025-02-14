defmodule DreamsBankApi.Accounts.UpdatingAndDeleteTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.Accounts

  describe "updating accounts" do
    test "update_account/2 with valid data updates an account" do
      account = insert(:account)
      new_owner = "New Owner"
      new_balance = Decimal.new("5000.00")

      {:ok, updated_account} =
        Accounts.update_account(account, %{owner: new_owner, balance: new_balance})

      assert updated_account.owner == new_owner
      assert updated_account.balance == new_balance
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = insert(:account)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account(account, %{balance: Decimal.new("-1000.00")})
    end
  end

  describe "deleting accounts" do
    test "delete_account/1 deletes an account" do
      account = insert(:account)

      assert Accounts.delete_account(account)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_account_by_number!(account.number)
      end
    end
  end
end
