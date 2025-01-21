defmodule BlindfoldChess.Repo.Migrations.CreateTacticsRatings do
  use Ecto.Migration

  def change do
    create table(:tactics_ratings) do
      add(:user_id, references(:profiles, type: :binary_id, on_delete: :delete_all))
      add(:moves, :integer)
      add(:rating_glicko, :float)
      add(:rating_glicko2, :float)
      add(:rating_deviation_glicko, :float)
      add(:rating_deviation_glicko2, :float)
      add(:rating_volatility_glicko, :float)
      add(:rating_volatility_glicko2, :float)

      timestamps(type: :utc_datetime)
    end

    create(index(:tactics_ratings, [:user_id]))
  end
end
