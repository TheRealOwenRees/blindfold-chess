defmodule BlindfoldChessWeb.TacticLive.FormComponent do
  use BlindfoldChessWeb, :live_component

  alias BlindfoldChess.Tactics

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage tactic records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tactic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:puzzle_id]} type="text" label="Puzzle" />
        <.input field={@form[:fen]} type="text" label="Fen" />
        <.input field={@form[:moves]} type="text" label="Moves" />
        <.input field={@form[:rating]} type="number" label="Rating" />
        <.input field={@form[:rating_deviation]} type="number" label="Rating deviation" />
        <.input field={@form[:popularity]} type="number" label="Popularity" />
        <.input field={@form[:nb_plays]} type="number" label="Nb plays" />
        <.input
          field={@form[:themes]}
          type="select"
          multiple
          label="Themes"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:game_url]} type="text" label="Game url" />
        <.input
          field={@form[:opening_tags]}
          type="select"
          multiple
          label="Opening tags"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tactic</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tactic: tactic} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tactics.change_tactic(tactic))
     end)}
  end

  @impl true
  def handle_event("validate", %{"tactic" => tactic_params}, socket) do
    changeset = Tactics.change_tactic(socket.assigns.tactic, tactic_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"tactic" => tactic_params}, socket) do
    save_tactic(socket, socket.assigns.action, tactic_params)
  end

  defp save_tactic(socket, :edit, tactic_params) do
    case Tactics.update_tactic(socket.assigns.tactic, tactic_params) do
      {:ok, tactic} ->
        notify_parent({:saved, tactic})

        {:noreply,
         socket
         |> put_flash(:info, "Tactic updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_tactic(socket, :new, tactic_params) do
    case Tactics.create_tactic(tactic_params) do
      {:ok, tactic} ->
        notify_parent({:saved, tactic})

        {:noreply,
         socket
         |> put_flash(:info, "Tactic created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
