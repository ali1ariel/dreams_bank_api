defmodule DreamsBankApi.Accounts.CreationTest do
  use DreamsBankApi.DataCase

  alias DreamsBankApi.Accounts

  describe "creating accounts" do
    test "create_account/1 with valid data creates an account" do
      attrs = params_for(:account, balance: Decimal.new("2500.00"))
      account = insert(:account, attrs)
      assert account.number == attrs.number
      assert account.owner == attrs.owner
      assert account.balance == Decimal.new("2500.00")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(%{})
    end

    test "create_account/1 with negative balance returns error" do
      attrs = params_for(:account, balance: Decimal.new("-1000.00"))
      assert {:error, changeset} = Accounts.create_account(attrs)
      assert "must be greater than or equal to 0" in errors_on(changeset).balance
    end

    test "create_account/1 with duplicate number returns error" do
      # Create first account
      account = insert(:account)

      # Try to create another account with same number
      attrs = params_for(:account, number: account.number)
      assert {:error, changeset} = Accounts.create_account(attrs)
      assert "has already been taken" in errors_on(changeset).number
    end
  end
end
