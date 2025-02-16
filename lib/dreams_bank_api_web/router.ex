defmodule DreamsBankApiWeb.Router do
  use DreamsBankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DreamsBankApiWeb do
    pipe_through :api

    resources "/accounts", AccountController, except: [:new, :edit]
    get "/accounts/number/:number", AccountController, :show_by_number

    post "/accounts/:account_number/deposit", BankController, :deposit
    post "/accounts/:account_number/withdrawal", BankController, :withdrawal
  end
end
