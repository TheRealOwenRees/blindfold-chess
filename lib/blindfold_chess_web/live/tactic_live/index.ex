defmodule BlindfoldChessWeb.TacticsLive.Index do
  use BlindfoldChessWeb, :live_view

  import BlindfoldChess.TacticsLive.Helpers

  @settings_form %{
    "number_of_moves" => "4",
    "user_rating" => "1500",
    "lower_rating_bound" => "200",
    "upper_rating_bound" => "200"
  }

  @impl true
  def mount(_params, _sessions, socket) do
    {:ok,
     socket
     |> assign(:live_action, :index)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(move_form: to_form(%{"move" => ""}))
     |> assign(settings_form: to_form(@settings_form))}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    case socket.assigns.live_action do
      :index -> {:noreply, socket}
      :show -> do_handle_show_params(socket)
    end
  end

  @impl true
  def handle_event("validate_settings", params, socket) do
    {:noreply, socket |> assign(:settings_form, to_form(params))}
  end

  def handle_event("validate_move", params, socket) do
    {:noreply, socket |> assign(:move_form, to_form(params))}
  end

  def handle_event("submit_settings", _params, socket), do: {:noreply, socket |> tactic_assigns()}

  def handle_event("submit_move", %{"move" => move}, socket) do
    # TODO fix, not working
    # {:noreply, push_event(socket, "checkLegalMove", %{"move" => move})}
    do_submit_move(socket, move)
  end

  def handle_event("give_up", _params, socket), do: do_fail_tactic(socket)
  def handle_event("next_tactic", _params, socket), do: {:noreply, socket |> tactic_assigns()}

  def handle_event("is_legal_move?", %{"move" => move, "legal" => false}, socket) do
    {:noreply, socket |> put_flash(:error, "Illegal move: #{move}")}
  end

  def handle_event("is_legal_move?", %{"move" => move, "legal" => true}, socket) do
    do_submit_move(socket, move)
  end

  defp do_handle_show_params(socket) do
    {:ok, tactic} = get_tactic(socket.assigns.settings_form.params)

    # push opponent's initial move
    socket = push_event(socket, "gameMove", %{"move" => Enum.at(tactic.moves, 0)})

    {:noreply,
     socket
     |> assign(:tactic, tactic)
     |> assign(:tactic_current_move, 1)
     |> assign(:tactic_status, :unsolved)
     |> assign(move_form: to_form(%{"move" => ""}))}
    |> dbg()
  end

  defp tactic_assigns(socket) do
    socket
    |> assign(:live_action, :show)
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> push_patch(to: ~p"/tactics/solve", replace: true)
  end

  defp do_submit_move(socket, move) do
    move_index = socket.assigns.tactic_current_move
    moves_list = socket.assigns.tactic.moves

    case Enum.at(moves_list, move_index) == move do
      false ->
        do_fail_tactic(socket)

      true ->
        if is_tactic_complete?(moves_list, move_index + 1) do
          do_complete_tactic(socket)
        else
          # push user's move to chess game
          socket =
            push_event(socket, "gameMove", %{
              "move" => Enum.at(socket.assigns.tactic.moves, move_index)
            })

          do_next_move(socket)
        end
    end
  end

  defp do_next_move(socket) do
    next_move_index = socket.assigns.tactic_current_move + 2

    # push opponent move to chess game
    socket =
      push_event(socket, "gameMove", %{
        "move" => Enum.at(socket.assigns.tactic.moves, next_move_index - 1)
      })

    {:noreply,
     socket
     |> assign(:tactic_current_move, next_move_index)
     |> assign(move_form: to_form(%{"move" => ""}))}
  end

  defp do_fail_tactic(socket) do
    {:noreply,
     socket
     |> assign(:tactic_status, :failed)
     |> put_flash(:error, "Tactic failed!")}
  end

  defp do_complete_tactic(socket) do
    {:noreply,
     socket
     |> assign(:tactic_status, :solved)
     |> put_flash(:info, "Tactic solved!")}
  end
end
