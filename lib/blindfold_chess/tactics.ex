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
  def get_tactic!(id) do
    Tactic
    |> Repo.get!(id)
    |> set_side_to_move()
    |> split_moves()
  end

  @doc """
  Gets a single tactic based on number of moves, user's rating, and upper and lower rating bounds.

  ## Examples

      iex> get_random_tactic_within_rating_bounds(4, 1500, 200, 200)
      {:ok, %Tactic{}}

      iex> get_random_tactic_within_rating_bounds(13, 1500, 200, 200)
      {:error, "No tactic found within rating bounds."}
  """
  def get_random_tactic_within_rating_bounds(moves, rating, lower_bound, upper_bound) do
    moves = moves - 1
    lower_bound = rating - lower_bound
    upper_bound = rating + upper_bound

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

  defp set_side_to_move(tactic) do
    side_to_move = extract_side_to_move(tactic.fen)
    %{tactic | side_to_move: side_to_move}
  end

  @spec extract_side_to_move(String.t()) :: atom()
  defp extract_side_to_move(fen) do
    fen
    |> String.split(" ")
    |> Enum.at(1)
    |> case do
      "w" -> :black
      "b" -> :white
    end
  end

  defp split_moves(tactic) do
    moves = String.split(tactic.moves, " ")
    %{tactic | moves: moves}
  end
end
