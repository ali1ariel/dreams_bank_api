defmodule DreamsBankApi.Repo do
  use Ecto.Repo,
    otp_app: :dreams_bank_api,
    adapter: Ecto.Adapters.Postgres
end
