defmodule DreamsBankApi.Factory do
  @moduledoc """
  This module defines factories for the DreamsBankApi application.
  """
  use ExMachina.Ecto, repo: DreamsBankApi.Repo

  def account_factory do
    %DreamsBankApi.Accounts.Account{
      number: sequence(:number, &"#{get_random_numbers(7)}-#{&1}"),
      owner: sequence(:owner, &"Owner #{&1}"),
      balance: Decimal.new("1000.00")
    }
  end

  def get_random_numbers(quantity) do
    1..quantity
    |> Enum.map_join(fn _ -> :rand.uniform(9) end)
  end
end
