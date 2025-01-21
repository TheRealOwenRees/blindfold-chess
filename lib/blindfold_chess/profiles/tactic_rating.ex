defmodule BlindfoldChess.Profiles.TacticRating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tactics_ratings" do
    field(:moves, :integer)
    field(:rating_glicko, :float)
    field(:rating_glicko2, :float)
    field(:rating_deviation_glicko, :float)
    field(:rating_deviation_glicko2, :float)
    field(:rating_volatility_glicko, :float)
    field(:rating_volatility_glicko2, :float)

    belongs_to(:user, BlindfoldChess.Profiles.Profile, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tactic_rating, attrs) do
    tactic_rating
    |> cast(attrs, [
      :user_id,
      :moves,
      :rating_glicko,
      :rating_glicko2,
      :rating_deviation_glicko,
      :rating_deviation_glicko2,
      :rating_volatility_glicko,
      :rating_volatility_glicko2
    ])
    |> validate_required([
      :user_id,
      :moves,
      :rating_glicko,
      :rating_glicko2,
      :rating_deviation_glicko,
      :rating_deviation_glicko2,
      :rating_volatility_glicko,
      :rating_volatility_glicko2
    ])
  end
end
