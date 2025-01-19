defmodule BlindfoldChess.Repo do
  use Ecto.Repo,
    otp_app: :blindfold_chess,
    adapter: Ecto.Adapters.Postgres
end
