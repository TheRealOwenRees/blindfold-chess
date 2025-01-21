defmodule BlindfoldChess.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all))
      add(:username, :string)
      add(:country, :string)
      add(:rating, :float, default: 0.0)
      add(:total_attempts, :integer, default: 0)
      add(:last_10_successful_tactics, {:array, :string}, default: [])
      add(:last_10_failed_tactics, {:array, :string}, default: [])
      add(:account_type, :string, default: "free")

      timestamps(type: :utc_datetime)
    end

    create(index(:profiles, [:user_id]))
    create(unique_index(:profiles, [:username]))
  end
end
