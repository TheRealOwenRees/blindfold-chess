defmodule BlindfoldChessWeb.PageController do
  use BlindfoldChessWeb, :controller

  def home(conn, _params) do
    # TODO move into auth login / resetting on logout
    profile = get_profile(conn)

    conn =
      case profile do
        nil -> conn
        _ -> assign(conn, :profile, build_profile_struct(conn, profile))
      end

    IO.inspect(conn.assigns)

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  defp build_profile_struct(conn, profile) do
    profile
    |> Map.merge(%{
      ratings: %{
        tactics_ratings: get_tactics_ratings(conn),
        rating_functions: rating_functions()
      }
    })
  end

  defp get_profile(conn) do
    case conn.assigns.current_user do
      nil ->
        nil

      user ->
        BlindfoldChess.Profiles.get_profile_by_user_id!(user.id)
    end
  end

  defp get_tactics_ratings(conn) do
    case conn.assigns.current_user do
      nil ->
        nil

      user ->
        BlindfoldChess.TacticsRatings.get_tactics_ratings_by_user_id!(user.id)
    end
  end

  defp rating_functions() do
    %{
      :new_player => &Exglicko2.new_player/0,
      :to_glicko => &Exglicko2.Rating.to_glicko/1
    }
  end
end
