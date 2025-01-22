defmodule BlindfoldChess.Profiles.Profile do
  @type binary_id :: Ecto.UUID.t()

  use Ecto.Schema
  import Ecto.Changeset

  alias BlindfoldChess.Ratings

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "profiles" do
    field(:username, :string)
    field(:country, :string)
    field(:account_type, :string)
    field(:ratings, :map, virtual: true)

    belongs_to(:users, BlindfoldChess.Accounts.User, foreign_key: :user_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [])
    |> validate_required([])
  end

  @doc """
  Build a profile struct to pass around the app with conn.

  Function references are passed to 'rating_functions', to be able to calculate rating change per user.

      %{
      profile: %BlindfoldChess.Profiles.Profile{
        __meta__: #Ecto.Schema.Metadata<:loaded, "profiles">,
        id: "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
        username: some_username,
        country: "France",
        account_type: "free",
        ratings: %{
          tactics_ratings: %{},
          rating_functions: %{
            new_player: &Exglicko2.new_player/0,
            to_glicko: &Exglicko2.Rating.to_glicko/1
          }
        },
  """
  @spec build_profile_with_ratings(binary_id()) :: %__MODULE__{}
  def build_profile_with_ratings(user_id) do
    %__MODULE__{
      BlindfoldChess.Profiles.get_profile_by_user_id!(user_id)
      | ratings: %{
          tactics_ratings: Ratings.get_tactics_ratings(user_id),
          rating_functions: Ratings.ratings_functions()
        }
    }
  end
end
