defmodule BlindfoldChess.TacticsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BlindfoldChess.Tactics` context.
  """

  @doc """
  Generate a tactic.
  """
  def tactic_fixture(attrs \\ %{}) do
    {:ok, tactic} =
      attrs
      |> Enum.into(%{
        fen: "some fen",
        game_url: "some game_url",
        moves: "some moves",
        nb_plays: 42,
        opening_tags: ["option1", "option2"],
        popularity: 42,
        puzzle_id: "some puzzle_id",
        rating: 42,
        rating_deviation: 42,
        themes: ["option1", "option2"]
      })
      |> BlindfoldChess.Tactics.create_tactic()

    tactic
  end
end
