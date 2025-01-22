defmodule BlindfoldChess.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all))
      add(:username, :string)
      add(:country, :string)
      add(:account_type, :string, default: "free")

      timestamps(type: :utc_datetime)
    end

    create(index(:profiles, [:user_id]))
    create(unique_index(:profiles, [:username]))
  end
end
