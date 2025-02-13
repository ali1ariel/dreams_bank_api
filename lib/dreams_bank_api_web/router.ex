defmodule DreamsBankApiWeb.Router do
  use DreamsBankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DreamsBankApiWeb do
    pipe_through :api
  end
end
