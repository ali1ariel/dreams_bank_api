defmodule DreamsBankApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DreamsBankApi.Accounts` context.
  """

  @doc """
  Generate a unique account number.
  """
  def unique_account_number, do: "some number#{System.unique_integer([:positive])}"

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        balance: "120.5",
        number: unique_account_number(),
        owner: "some owner"
      })
      |> DreamsBankApi.Accounts.create_account()

    account
  end
end
