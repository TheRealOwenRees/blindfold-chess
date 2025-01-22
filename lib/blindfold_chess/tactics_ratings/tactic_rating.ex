defmodule BlindfoldChess.TacticsRatings.TacticRating do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tactics_ratings" do
    field(:moves, :integer)
    field(:rating_glicko, :float)
    field(:rating_glicko2, :float)
    field(:rating_deviation_glicko, :float)
    field(:rating_deviation_glicko2, :float)
    field(:rating_volatility_glicko, :float)
    field(:rating_volatility_glicko2, :float)

    belongs_to(:profiles, BlindfoldChess.Profiles.Profile,
      foreign_key: :user_id,
      type: :binary_id
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tactic_rating, attrs) do
    tactic_rating
    |> cast(attrs, [])
    |> validate_required([])
  end
end
