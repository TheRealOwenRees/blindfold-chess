defmodule BlindfoldChess.TacticsRatings do
  import Ecto.Query, warn: false
  alias BlindfoldChess.Repo

  alias BlindfoldChess.TacticsRatings.TacticRating

  def list_tactics_ratings do
    Repo.all(TacticRating)
  end

  def get_tactics_ratings!(id), do: Repo.get!(TacticRating, id)

  def get_tactics_ratings_by_user_id!(user_id), do: Repo.get_by(TacticRating, user_id: user_id)
end
