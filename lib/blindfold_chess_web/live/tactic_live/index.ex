defmodule BlindfoldChessWeb.TacticsLive.Index do
  use BlindfoldChessWeb, :live_view

  import BlindfoldChess.TacticsLive.Helpers

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
    case socket.assigns.live_action do
      :index ->
        {:noreply, socket}

      :show ->
        {:ok, tactic} = get_tactic(socket.assigns.form.params)

        {:noreply,
         socket
         |> assign(:tactic, tactic)
         |> assign(:tactic_current_move, 1)
         |> assign(:tactic_status, :unsolved)}
    end
  end

  @impl true
  # TODO - validate input
  def handle_event("validate", _params, socket) do
    # typically the phx-change event is used for live validation of form data
    {:noreply, socket}
  end

  def handle_event("submit", _params, socket), do: {:noreply, socket |> tactic_assigns()}
  def handle_event("next_tactic", _params, socket), do: {:noreply, socket |> tactic_assigns()}

  def handle_event("submit_move", %{"move" => move}, socket) do
    check_move_is_correct?(socket.assigns.tactic.moves, move, 1)
    |> dbg()

    {:noreply,
     socket
     |> assign(:tactic_current_move, socket.assigns.tactic_current_move + 1)}
    |> dbg()
  end

  defp tactic_assigns(socket) do
    socket
    |> assign(:live_action, :show)
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> push_patch(to: ~p"/tactics/solve", replace: true)
  end
end
