defmodule BlindfoldChess.Ratings do
  @moduledoc """
  The Ratings context, responsible for managing ratings.
  """

  @doc """
  Ratings functions references, used in the Profile struct to calculate ratings.
  """
  def ratings_functions do
    %{
      :new_player => &Exglicko2.new_player/0,
      :to_glicko => &Exglicko2.Rating.to_glicko/1
    }
  end

  @doc """
  Get the tactics ratings for a user.
  """
  def get_tactics_ratings(user_id) do
    BlindfoldChess.TacticsRatings.get_tactics_ratings_by_user_id!(user_id)
  end
end
