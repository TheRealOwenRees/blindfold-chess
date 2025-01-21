defmodule BlindfoldChess.Profiles.Profile do
  use BlindfoldChess.UUIDKeysSchema
  import Ecto.Changeset

  schema "profiles" do
    field :username, :string
    field :full_name, :string
    field :country, :string
    field :rating, :float
    field :last_10_successful_tactics, {:array, :string}
    field :last_10_failed_tactics, {:array, :string}
    field :total_attempts, :integer
    field :account_type, :string
    belongs_to :user, BlindfoldChess.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [])
    |> validate_required([])
  end
end
