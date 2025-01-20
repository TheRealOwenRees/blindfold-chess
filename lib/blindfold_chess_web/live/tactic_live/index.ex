defmodule BlindfoldChessWeb.TacticLive.Index do
  use BlindfoldChessWeb, :live_view

  alias BlindfoldChess.Tactics
  alias BlindfoldChess.Tactics.Tactic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tactics, Tactics.list_tactics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tactic")
    |> assign(:tactic, Tactics.get_tactic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tactic")
    |> assign(:tactic, %Tactic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tactics")
    |> assign(:tactic, nil)
  end

  @impl true
  def handle_info({BlindfoldChessWeb.TacticLive.FormComponent, {:saved, tactic}}, socket) do
    {:noreply, stream_insert(socket, :tactics, tactic)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tactic = Tactics.get_tactic!(id)
    {:ok, _} = Tactics.delete_tactic(tactic)

    {:noreply, stream_delete(socket, :tactics, tactic)}
  end
end
