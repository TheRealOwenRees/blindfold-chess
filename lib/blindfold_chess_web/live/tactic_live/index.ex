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
    |> dbg()
  end

  @impl true
  def handle_event("validate", params, socket), do: do_validate(params, socket)
  def handle_event("submit", _params, socket), do: {:noreply, socket |> tactic_assigns()}
  def handle_event("next_tactic", _params, socket), do: {:noreply, socket |> tactic_assigns()}
  def handle_event("submit_move", %{"move" => move}, socket), do: validate_move(socket, move)
  def handle_event("give_up", _params, socket), do: do_give_up(socket)

  def handle_event("move_validated", %{"move" => move, "valid" => true}, socket) do
    check_move(socket, move)
  end

  def handle_event("move_validated", %{"move" => move, "valid" => false}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "Invalid move: #{move}")}
  end

  # TODO - validate input - only allow valid moves, not blacnk etc
  defp do_validate(params, socket) do
    {:noreply, socket}
  end

  # TODO show correct moves
  defp do_give_up(socket) do
    {:noreply,
     socket
     |> assign(:tactic_status, :failed)
     |> put_flash(:error, "Tactic failed!")}
  end

  defp tactic_assigns(socket) do
    socket
    |> assign(:live_action, :show)
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> push_patch(to: ~p"/tactics/solve", replace: true)
  end

  # TODO clear input on submit
  defp check_move(socket, move) do
    case is_move_correct?(socket.assigns.tactic.moves, move, socket.assigns.tactic_current_move) do
      false ->
        {:noreply,
         socket
         |> assign(:tactic_status, :failed)
         |> put_flash(:error, "Incorrect move!")}

      true ->
        if is_tactic_complete?(
             socket.assigns.tactic.moves,
             socket.assigns.tactic_current_move + 2
           ) do
          {:noreply,
           socket
           |> assign(:tactic_status, :solved)
           |> put_flash(:info, "Tactic solved!")}
        else
          {:noreply,
           socket |> assign(:tactic_current_move, socket.assigns.tactic_current_move + 2)}
        end
    end
    |> dbg()
  end

  defp validate_move(socket, move) do
    {:noreply, push_event(socket, "validateMove", %{"move" => move})}
  end
end
