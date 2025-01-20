defmodule BlindfoldChess.Repo.Migrations.CreateTactics do
  use Ecto.Migration

  def change do
    create table(:tactics, primary_key: false) do
      add :id, :binary_id, primary_key: true
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
      add :source, :string

      timestamps(updated_at: false, type: :utc_datetime_usec)
    end

    create(unique_index(:tactics, [:puzzle_id, :source]))
  end
end
