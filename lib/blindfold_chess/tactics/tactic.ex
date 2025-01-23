defmodule BlindfoldChess.Tactics.Tactic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tactics" do
    field(:puzzle_id, :string)
    field(:fen, :string)
    field(:moves, :string)
    field(:rating, :integer)
    field(:rating_deviation, :integer)
    field(:popularity, :integer)
    field(:nb_plays, :integer)
    field(:themes, {:array, :string})
    field(:game_url, :string)
    field(:opening_tags, {:array, :string})
    field(:source, :string)
    field(:side_to_move, :map, virtual: true)

    timestamps(updated_at: false, type: :utc_datetime_usec)
  end

  def changeset(tactic, attrs) do
    tactic
    |> cast(attrs, [
      :puzzle_id,
      :fen,
      :moves,
      :rating,
      :rating_deviation,
      :popularity,
      :nb_plays,
      :themes,
      :game_url,
      :opening_tags
    ])
    |> validate_required([
      :puzzle_id,
      :fen,
      :moves,
      :rating,
      :rating_deviation,
      :popularity,
      :nb_plays,
      :themes,
      :game_url,
      :opening_tags
    ])
  end
end
