defmodule BlindfoldChessWeb.TacticsLive.Index do
  use BlindfoldChessWeb, :live_view

  alias BlindfoldChess.Tactics
  alias BlindfoldChess.Tactics.Tactic

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       form:
         to_form(%{
           "number_of_moves" => "4",
           "user_rating" => "1500",
           "lower_rating_bound" => "200",
           "upper_rating_bound" => "200"
         })
     )}
  end

  def handle_event("validate", _params, socket) do
    # typically the phx-change event is used for live validation of form data
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", _params, socket) do
    form_data = socket.assigns.form

    # TODO pass to storage - local storage or session storage
    tactics_options = %{
      number_of_moves: form_data["number_of_moves"].value,
      user_rating: form_data["user_rating"].value,
      lower_rating_bound: form_data["lower_rating_bound"].value,
      upper_rating_bound: form_data["upper_rating_bound"].value
    }

    {:ok, tactic} =
      Tactics.get_random_tactic_within_rating_bounds(
        tactics_options.number_of_moves,
        tactics_options.user_rating,
        tactics_options.lower_rating_bound,
        tactics_options.upper_rating_bound
      )

    {:noreply,
     socket
     |> push_navigate(to: ~p"/tactics/#{tactic.id}")}
  end

  defp page_title(:index), do: "Blindfold Tactics"
end
