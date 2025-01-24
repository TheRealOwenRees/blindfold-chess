defmodule BlindfoldChessWeb.TacticsLive.Index do
  use BlindfoldChessWeb, :live_view

  alias BlindfoldChess.Tactics
  alias BlindfoldChess.Tactics.Tactic

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:live_action, :index)
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

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  # TODO - sanitise input
  def handle_event("validate", _params, socket) do
    # typically the phx-change event is used for live validation of form data
    {:noreply, socket}
  end

  def handle_event("submit", params, socket) do
    {:ok, tactic} = get_tactic(params)

    {:noreply,
     socket
     |> assign(:live_action, :show)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tactic, tactic)
     |> push_patch(to: ~p"/tactics/#{tactic.id}", replace: true)}
  end

  def handle_event("next_tactic", params, socket) do
    form_params = socket.assigns.form.params
    {:ok, tactic} = get_tactic(form_params)

    {:noreply,
     socket
     |> assign(:live_action, :show)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tactic, tactic)
     |> push_patch(to: ~p"/tactics/#{tactic.id}", replace: true)}
  end

  defp page_title(:index), do: "Blindfold Chess - Setup Tactics"
  defp page_title(:show), do: "Blindfold Chess - Solve Tactic"

  defp get_tactic(params) do
    number_of_moves = params["number_of_moves"]
    user_rating = params["user_rating"]
    lower_rating_bound = params["lower_rating_bound"]
    upper_rating_bound = params["upper_rating_bound"]

    {:ok, tactic} =
      Tactics.get_random_tactic_within_rating_bounds(
        String.to_integer(number_of_moves),
        String.to_integer(user_rating),
        String.to_integer(lower_rating_bound),
        String.to_integer(upper_rating_bound)
      )
  end
end
