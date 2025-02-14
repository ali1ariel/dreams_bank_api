defmodule DreamsBankApi.Accounts.Account do
  @moduledoc """
  The schema for the accounts table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :owner, :string
    field :number, :string
    field :balance, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:owner, :balance])
    |> validate_required([:owner, :balance])
    |> put_number_account(account.number)
    |> unique_constraint(:number)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end

  def put_number_account(changeset, nil) do
    changeset
    |> put_change(:number, "#{get_random_numbers(7)}-#{get_random_numbers(1)}")
  end

  def put_number_account(changeset, _) do
    changeset
  end

  def get_random_numbers(quantity) do
    1..quantity
    |> Enum.map_join(fn _ -> :rand.uniform(9) end)
  end
end
