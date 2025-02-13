defmodule DreamsBankApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DreamsBankApiWeb.Telemetry,
      DreamsBankApi.Repo,
      {DNSCluster, query: Application.get_env(:dreams_bank_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DreamsBankApi.PubSub},
      # Start a worker by calling: DreamsBankApi.Worker.start_link(arg)
      # {DreamsBankApi.Worker, arg},
      # Start to serve requests, typically the last entry
      DreamsBankApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DreamsBankApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DreamsBankApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
