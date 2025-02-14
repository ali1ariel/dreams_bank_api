defmodule DreamsBankApi.Accounts.Account do
  @moduledoc """
  The schema for the accounts table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type binary_id :: Ecto.UUID.t()

  @type t :: %__MODULE__{
          id: binary_id(),
          owner: String.t(),
          number: String.t(),
          balance: Decimal.t(),
          deposit: Decimal.t(),
          withdrawal: Decimal.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :owner, :string
    field :number, :string
    field :balance, :decimal

    field :deposit, :decimal, virtual: true
    field :withdrawal, :decimal, virtual: true

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

  @doc false
  def deposit(account, amount) do
    account
    |> change_balance(Decimal.new(amount))
    |> put_change(:deposit, Decimal.new(amount))
    |> validate_number(:deposit, greater_than_or_equal_to: 0)
  end

  defp change_balance(account, amount) do
    new_balance = Decimal.add(account.balance, amount)

    account
    |> changeset(%{balance: new_balance})
  end

  defp put_number_account(changeset, nil) do
    changeset
    |> put_change(:number, "#{get_random_numbers(7)}-#{get_random_numbers(1)}")
  end

  defp put_number_account(changeset, _) do
    changeset
  end

  defp get_random_numbers(quantity) do
    1..quantity
    |> Enum.map_join(fn _ -> :rand.uniform(9) end)
  end
end
