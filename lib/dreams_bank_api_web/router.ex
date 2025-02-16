defmodule DreamsBankApiWeb.Router do
  use DreamsBankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug DreamsBankApiWeb.LoadBalancerPlug
  end

  scope "/api", DreamsBankApiWeb do
    pipe_through :api

    resources "/accounts", AccountController, except: [:new, :edit]
    get "/accounts/number/:number", AccountController, :show_by_number

    post "/accounts/:account_number/deposit", BankController, :deposit
    post "/accounts/:account_number/withdrawal", BankController, :withdrawal
    post "/accounts/transfer", BankController, :transfer
  end
end
