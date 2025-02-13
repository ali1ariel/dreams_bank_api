defmodule DreamsBankApi.Accounts.Account do
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
    |> cast(attrs, [:number, :owner, :balance])
    |> validate_required([:number, :owner, :balance])
    |> unique_constraint(:number)
  end
end
