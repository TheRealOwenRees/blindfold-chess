defmodule BlindfoldChess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BlindfoldChessWeb.Telemetry,
      BlindfoldChess.Repo,
      {DNSCluster, query: Application.get_env(:blindfold_chess, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BlindfoldChess.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BlindfoldChess.Finch},
      # Start a worker by calling: BlindfoldChess.Worker.start_link(arg)
      # {BlindfoldChess.Worker, arg},
      # Start to serve requests, typically the last entry
      BlindfoldChessWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlindfoldChess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlindfoldChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
