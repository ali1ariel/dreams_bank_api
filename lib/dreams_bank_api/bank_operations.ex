defmodule DreamsBankApi.BankOperations do
  @moduledoc """
  Module responsible for the bank operations.
  """
  alias DreamsBankApi.Accounts.Account
  alias DreamsBankApi.Repo

  @doc """
  Deposits money into an account.

  ## Examples

      iex> account = insert(:account, balance: Decimal.new("2500.00"))
      iex> BankOperations.deposit(account, Decimal.new("500.00"))
      {:ok, %Account{balance: Decimal.new("3000.00")}}

      iex> account = insert(:account, balance: Decimal.new("2500.00"))
      iex> BankOperations.deposit(account, "-500.00")
      {:error, %Ecto.Changeset{errors: [deposit: {"must be greater than or equal to 0", []}]}}
  """
  @spec deposit(Account.t(), Decimal.t() | binary()) ::
          {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def deposit(account, amount) do
    account
    |> Account.deposit(amount)
    |> Repo.update()
  end

  @doc """
  Withdraws money from an account.

  ## Examples

      iex> account = insert(:account, balance: Decimal.new("2500.00"))
      iex> BankOperations.withdrawal(account, Decimal.new("500.00"))
      {:ok, %Account{balance: Decimal.new("2000.00")}}

      iex> account = insert(:account, balance: Decimal.new("2500.00"))
      iex> BankOperations.withdrawal(account, "-500.00")
      {:error, %Ecto.Changeset{errors: [withdrawal: {"must be less than or equal to 0", []}]}}
  """
  @spec withdrawal(Account.t(), Decimal.t() | binary()) ::
          {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def withdrawal(account, amount) do
    account
    |> Account.withdrawal(amount)
    |> Repo.update()
  end
end
