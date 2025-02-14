defmodule DreamsBankApi.Accounts.ListingAndSearchingTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.Accounts

  describe "listing accounts" do
    test "list_accounts/0 returns a list of accounts" do
      accounts = insert_list(3, :account)

      assert accounts == Accounts.list_accounts()
    end
  end

  describe "searching accounts" do
    test "get_account!/1 returns an account" do
      account = insert(:account)

      assert account == Accounts.get_account!(account.id)
    end

    test "get_account!/1 raises Ecto.NoResultsError if account does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_account!(Faker.UUID.v4())
      end
    end

    test "get_account_by_number!/1 returns an account" do
      account =
        insert(:account)

      assert account == Accounts.get_account_by_number!(account.number)
    end

    test "get_account_by_number!/1 raises Ecto.NoResultsError if account does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_account_by_number!("123")
      end
    end
  end
end
