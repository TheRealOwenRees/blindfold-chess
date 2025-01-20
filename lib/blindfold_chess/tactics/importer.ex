defmodule BlindfoldChess.Tactics.Importer do
  @moduledoc """
  Module for tactics parsing and generation.

  The only exposed function is `start/0`, which downloads the tactics CSV collection from Lichess, extracts it, processes it, and adds the tactics to the database.
  """
  alias BlindfoldChess.Repo

  @puzzle_url "https://database.lichess.org/lichess_db_puzzle.csv.zst"
  @puzzle_input_path "priv/data/lichess_db_puzzle.csv.zst"
  @puzzle_output_path "priv/data/lichess_db_puzzle.csv"

  def start() do
    with {:ok, _} <- download_lichess_tactics(),
         {:ok, _} <- extract_zst_file(),
         {:ok, _} <- delete_zst_file(),
         {:ok, _} <- process_tactics_csv() do
      {:ok, "Tactics downloaded and added to the database."}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp download_lichess_tactics() do
    File.mkdir_p!("priv/data")

    case(Finch.build(:get, @puzzle_url) |> Finch.request(BlindfoldChess.Finch)) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        File.write!(@puzzle_input_path, body)
        {:ok, "Downloaded tactics CSV collection."}

      {:ok, %Finch.Response{status: 404}} ->
        {:error, "Tactics CSV collection not found."}

      {:error, reason} ->
        {:error, "Failed to download tactics CSV collection: #{inspect(reason)}"}
    end
  end

  defp extract_zst_file() do
    case System.cmd("zstd", ["-d", @puzzle_input_path, "-o", @puzzle_output_path]) do
      {_, 0} -> {:ok, "Extracted tactics CSV collection."}
      {_, code} -> {:error, "Failed to extract tactics CSV collection: #{code}"}
    end
  end

  defp delete_zst_file() do
    case File.rm(@puzzle_input_path) do
      :ok -> {:ok, "Deleted ZST file."}
      _ -> {:error, "Failed to delete ZST file."}
    end
  end

  defp generate_tactic_map([
         puzzle_id,
         fen,
         moves,
         rating,
         rating_deviation,
         popularity,
         nb_plays,
         themes,
         game_url,
         opening_tags
       ]) do
    %{
      puzzle_id: puzzle_id,
      fen: fen,
      moves: moves,
      rating: String.to_integer(rating),
      rating_deviation: String.to_integer(rating_deviation),
      popularity: String.to_integer(popularity),
      nb_plays: String.to_integer(nb_plays),
      themes: String.split(themes, " "),
      game_url: game_url,
      opening_tags: String.split(opening_tags, " "),
      source: "lichess"
    }
  end

  defp process_tactics_csv() do
    try do
      @puzzle_output_path
      |> File.stream!()
      |> Stream.drop(1)
      |> Stream.chunk_every(5000)
      |> Stream.each(fn chunk ->
        entries =
          chunk
          |> Stream.map(&String.trim(&1))
          |> Stream.map(&String.split(&1, ","))
          |> Stream.map(&generate_tactic_map/1)
          |> Stream.map(fn entry ->
            Map.merge(entry, %{inserted_at: DateTime.utc_now()})
          end)
          |> Enum.to_list()

        Repo.insert_all(BlindfoldChess.Tactics.Tactic, entries, on_conflict: :nothing)
      end)
      |> Stream.run()

      {:ok, "Processed tactics CSV collection."}
    rescue
      e in Ecto.MigrationError ->
        {:error, "Failed to process tactics CSV collection: #{e.message}"}
    end
  end
end
