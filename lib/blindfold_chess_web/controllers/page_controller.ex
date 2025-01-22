defmodule BlindfoldChessWeb.PageController do
  use BlindfoldChessWeb, :controller
  alias BlindfoldChess.Profiles.Profile

  def home(conn, _params) do
    conn =
      case conn.assigns.current_user do
        nil ->
          conn

        user ->
          assign(
            conn,
            :profile,
            Profile.build_profile_with_ratings(user.id)
          )
      end

    IO.inspect(conn.assigns)

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
