defmodule BlindfoldChess.TacticsLive.Helpers do
  @moduledoc """
  Helper functions for the BlindfoldChess.TacticsLive module
  """

  alias BlindfoldChess.Tactics

  @doc """
  Check the user's move against the current move number in the moves list
  """
  @spec is_move_correct?(list(), String.t(), integer()) :: boolean()
  def is_move_correct?(moves_list, user_move, current_move) do
    expected_move = Enum.at(moves_list, current_move)
    user_move == expected_move

    # Enum.at(tactic_moves, move_number) == user_move
  end

  @doc """
  Check if the next move number is greater than or equal to the length of the moves list
  """
  def is_tactic_complete?(moves_list, current_move), do: current_move >= length(moves_list)

  @doc """
  Get a random tactic within the constraints of the submitted form data
  """
  def get_tactic(params) do
    number_of_moves = params["number_of_moves"]
    user_rating = params["user_rating"]
    lower_rating_bound = params["lower_rating_bound"]
    upper_rating_bound = params["upper_rating_bound"]

    {:ok, _} =
      Tactics.get_random_tactic_within_rating_bounds(
        String.to_integer(number_of_moves),
        String.to_integer(user_rating),
        String.to_integer(lower_rating_bound),
        String.to_integer(upper_rating_bound)
      )
  end

  def page_title(:index), do: "Blindfold Chess | Setup Tactics"
  def page_title(:show), do: "Blindfold Chess | Solve Tactic"
end
