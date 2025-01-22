defmodule BlindfoldChess.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "profiles" do
    field(:username, :string)
    field(:country, :string)
    field(:account_type, :string)

    belongs_to(:users, BlindfoldChess.Accounts.User, foreign_key: :user_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [])
    |> validate_required([])
  end
end
