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
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:live_action, :show)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tactic, Tactics.get_tactic!(id))}
    |> dbg()
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    # typically the phx-change event is used for live validation of form data
    {:noreply, socket}
  end

  def handle_event("submit", params, socket) do
    form_data = params
    # form_data = socket.assigns.form
    IO.inspect(form_data)

    number_of_moves = form_data["number_of_moves"]
    user_rating = form_data["user_rating"]
    lower_rating_bound = form_data["lower_rating_bound"]
    upper_rating_bound = form_data["upper_rating_bound"]

    IO.inspect({number_of_moves, user_rating, lower_rating_bound, upper_rating_bound})

    # number_of_moves = form_params["number_of_moves"]
    # user_rating = form_params["user_rating"]
    # lower_rating_bound = form_params["lower_rating_bound"]
    # upper_rating_bound = form_params["upper_rating_bound"]

    # # TODO pass to storage - local storage or session storage
    # tactics_options = %{
    #   number_of_moves: form_data["number_of_moves"].value,
    #   user_rating: form_data["user_rating"].value,
    #   lower_rating_bound: form_data["lower_rating_bound"].value,
    #   upper_rating_bound: form_data["upper_rating_bound"].value
    # }

    {:ok, tactic} =
      Tactics.get_random_tactic_within_rating_bounds(
        String.to_integer(number_of_moves),
        String.to_integer(user_rating),
        String.to_integer(lower_rating_bound),
        String.to_integer(upper_rating_bound)
      )

    {:noreply,
     socket
     |> push_patch(to: ~p"/tactics/#{tactic.id}", replace: true)}

    #  |> push_navigate(to: ~p"/tactics/#{tactic.id}")}
  end

  defp page_title(:index), do: "Setup Tactics"
  defp page_title(:show), do: "Show Tactic"
end
