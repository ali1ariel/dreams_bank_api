defmodule DreamsBankApi.BankService do
  @moduledoc """
  This module provides a service layer for the bank operations.
  """
  alias DreamsBankApi.Accounts
  alias DreamsBankApi.Accounts.Account
  alias DreamsBankApi.BankOperations

  @type operation_response ::
          {:ok, Account.t() | map()}
          | {:error,
             :not_found | :insufficient_funds | :invalid_amount | :same_account | String.t()}

  @doc """
  Performs a deposit operation with user-friendly error handling.

  ## Examples

      iex> Accounts.create_account("1234567-8", "100.00")
      {:ok, %Account{} = account}

      iex> BankService.deposit("1234567-8", "100.00")
      {:ok, %Account{}}

      iex> BankService.deposit("1234567-8", "100.00")
      {:error, :invalid_amount}

      iex> BankService.deposit("invalid-account", "100.00")
      {:error, :not_found}
  """
  @spec deposit(String.t(), String.t() | Decimal.t()) :: operation_response
  def deposit(account_number, amount) do
    with {:ok, %Account{} = account} <- get_account(account_number),
         {:ok, %Account{} = updated_account} <- BankOperations.deposit(account, amount) do
      {:ok, updated_account}
    else
      {:error, %Ecto.Changeset{errors: [deposit: {_msg, _}]}} ->
        {:error, :invalid_amount}

      # Not mapped error
      # coveralls-ignore-start
      {:error, %Ecto.Changeset{}} ->
        {:error, :not_defined}

      error ->
        error
        # coveralls-ignore-stop
    end
  end

  @doc """
  Performs a withdrawal operation with user-friendly error handling.

  ## Examples

      iex> BankService.withdrawal("1234567-8", "100.00")
      {:ok, %Account{}}

      iex> BankService.withdrawal("1234567-8", "5000.00")
      {:error, :insufficient_funds}
  """
  @spec withdrawal(String.t(), String.t() | Decimal.t()) :: operation_response
  def withdrawal(account_number, amount) do
    with {:ok, account} <- get_account(account_number),
         {:ok, updated_account} <- BankOperations.withdrawal(account, amount) do
      {:ok, updated_account}
    else
      {:error, %Ecto.Changeset{errors: [balance: {_msg, _}]}} ->
        {:error, :insufficient_funds}

      {:error, %Ecto.Changeset{errors: [withdrawal: {_msg, _}]}} ->
        {:error, :invalid_amount}

      # coveralls-ignore-start
      {:error, %Ecto.Changeset{}} ->
        {:error, :not_defined}

      error ->
        error
        # coveralls-ignore-stop
    end
  end

  @doc """
  Performs a transfer operation with user-friendly error handling.

  ## Examples

      iex> BankService.transfer("1234567-8", "8765432-1", "100.00")
      {:ok, %{from: %Account{}, to: %Account{}}}

      iex> BankService.transfer("1234567-8", "1234567-8", "100.00")
      {:error, :same_account}

      iex> BankService.transfer("1234567-8", "8765432-1", "5000.00")
      {:error, :insufficient_funds}
  """
  @spec transfer(String.t(), String.t(), String.t() | Decimal.t()) :: operation_response
  def transfer(from_account_number, to_account_number, amount) do
    with {:different_accounts} <-
           validate_different_accounts(from_account_number, to_account_number),
         {:ok, from_account} <- get_account(from_account_number),
         {:ok, to_account} <- get_account(to_account_number),
         {:ok, %{withdrawal: from_updated, deposit: to_updated}} <-
           BankOperations.transfer(from_account, to_account, amount) do
      {:ok, %{from: from_updated, to: to_updated}}
    else
      {:same_account} ->
        {:error, :same_account}

      {:error, :withdrawal, %Ecto.Changeset{errors: [balance: {_msg, _}]}, _} ->
        {:error, :insufficient_funds}

      # coveralls-ignore-start
      {:error, _operation, %Ecto.Changeset{}, _} ->
        {:error, :not_defined}

      error ->
        error
        # coveralls-ignore-stop
    end
  end

  defp get_account(account_number) do
    {:ok, Accounts.get_account_by_number!(account_number)}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

  defp validate_different_accounts(account_number, account_number), do: {:same_account}
  defp validate_different_accounts(_, _), do: {:different_accounts}
end
