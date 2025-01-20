defmodule BlindfoldChess.Repo.Migrations.CreateTactics do
  use Ecto.Migration

  def change do
    create table(:tactics) do
      add :puzzle_id, :string
      add :fen, :string
      add :moves, :string
      add :rating, :integer
      add :rating_deviation, :integer
      add :popularity, :integer
      add :nb_plays, :integer
      add :themes, {:array, :string}
      add :game_url, :string
      add :opening_tags, {:array, :string}

      timestamps(updated_at: false, type: :utc_datetime_usec)
    end
  end
end
