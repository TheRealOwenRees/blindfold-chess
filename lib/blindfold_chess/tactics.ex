defmodule BlindfoldChess.Tactics do
  import Ecto.Query, only: [from: 2]

  alias BlindfoldChess.Repo
  alias BlindfoldChess.Tactics.{Importer, Tactic}

  def import_tactics() do
    if !File.exists?("priv/data/lichess_db_puzzle.csv") do
      case Importer.start() do
        {:ok, _} -> IO.puts("Tactics imported.")
        {:error, reason} -> IO.puts("Failed to import tactics: #{reason}")
      end
    else
      IO.puts("Tactics already downloaded.")
    end
  end

  @doc """
  Returns the list of tactics.

  ## Examples

      iex> list_tactics()
      [%Tactic{}, ...]

  """
  def list_tactics do
    Repo.all(Tactic)
  end

  @doc """
  Gets a single tactic.

  Raises `Ecto.NoResultsError` if the Tactic does not exist.

  ## Examples

      iex> get_tactic!(123)
      %Tactic{}

      iex> get_tactic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tactic!(id), do: Repo.get!(Tactic, id)

  @doc """
  Gets a single tactic based on number of moves, user's rating, and upper and lower rating bounds.

  ## Examples

      iex> get_random_tactic_within_rating_bounds(4, 1500, 200, 200)
      {:ok, %Tactic{}}

      iex> get_random_tactic_within_rating_bounds(13, 1500, 200, 200)
      {:error, "No tactic found within rating bounds."}
  """
  def get_random_tactic_within_rating_bounds(moves, rating, lower_bound, upper_bound) do
    moves = String.to_integer(moves) - 1
    rating = String.to_integer(rating)
    lower_bound = rating - String.to_integer(lower_bound)
    upper_bound = rating + String.to_integer(upper_bound)

    query =
      from(t in Tactic,
        where: t.rating >= ^lower_bound and t.rating <= ^upper_bound,
        where:
          fragment(
            "char_length(?) - char_length(replace(?, ' ', '')) = ?",
            t.moves,
            t.moves,
            ^moves
          ),
        order_by: fragment("RANDOM()"),
        limit: 1
      )

    case Repo.one(query) do
      nil -> {:error, "No tactic found within rating bounds."}
      tactic -> {:ok, tactic}
    end
  end

  @doc """
  Creates a tactic.

  ## Examples

      iex> create_tactic(%{field: value})
      {:ok, %Tactic{}}

      iex> create_tactic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tactic(attrs \\ %{}) do
    %Tactic{}
    |> Tactic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tactic.

  ## Examples

      iex> update_tactic(tactic, %{field: new_value})
      {:ok, %Tactic{}}

      iex> update_tactic(tactic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tactic(%Tactic{} = tactic, attrs) do
    tactic
    |> Tactic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tactic.

  ## Examples

      iex> delete_tactic(tactic)
      {:ok, %Tactic{}}

      iex> delete_tactic(tactic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tactic(%Tactic{} = tactic) do
    Repo.delete(tactic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tactic changes.

  ## Examples

      iex> change_tactic(tactic)
      %Ecto.Changeset{data: %Tactic{}}

  """
  def change_tactic(%Tactic{} = tactic, attrs \\ %{}) do
    Tactic.changeset(tactic, attrs)
  end
end
