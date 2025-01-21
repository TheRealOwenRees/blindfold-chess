defmodule BlindfoldChessWeb.TacticLive.Show do
  use BlindfoldChessWeb, :live_view

  alias BlindfoldChess.Tactics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tactic, Tactics.get_tactic!(id))}
  end

  defp page_title(:show), do: "Solve Tactic"
end
