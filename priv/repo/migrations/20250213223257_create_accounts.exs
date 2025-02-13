defmodule DreamsBankApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :number, :string
      add :owner, :string
      add :balance, :decimal

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:number])
  end
end
