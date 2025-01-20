defmodule BlindfoldChess.TacticsTest do
  use BlindfoldChess.DataCase

  alias BlindfoldChess.Tactics

  describe "tactics" do
    alias BlindfoldChess.Tactics.Tactic

    import BlindfoldChess.TacticsFixtures

    @invalid_attrs %{puzzle_id: nil, fen: nil, moves: nil, rating: nil, rating_deviation: nil, popularity: nil, nb_plays: nil, themes: nil, game_url: nil, opening_tags: nil}

    test "list_tactics/0 returns all tactics" do
      tactic = tactic_fixture()
      assert Tactics.list_tactics() == [tactic]
    end

    test "get_tactic!/1 returns the tactic with given id" do
      tactic = tactic_fixture()
      assert Tactics.get_tactic!(tactic.id) == tactic
    end

    test "create_tactic/1 with valid data creates a tactic" do
      valid_attrs = %{puzzle_id: "some puzzle_id", fen: "some fen", moves: "some moves", rating: 42, rating_deviation: 42, popularity: 42, nb_plays: 42, themes: ["option1", "option2"], game_url: "some game_url", opening_tags: ["option1", "option2"]}

      assert {:ok, %Tactic{} = tactic} = Tactics.create_tactic(valid_attrs)
      assert tactic.puzzle_id == "some puzzle_id"
      assert tactic.fen == "some fen"
      assert tactic.moves == "some moves"
      assert tactic.rating == 42
      assert tactic.rating_deviation == 42
      assert tactic.popularity == 42
      assert tactic.nb_plays == 42
      assert tactic.themes == ["option1", "option2"]
      assert tactic.game_url == "some game_url"
      assert tactic.opening_tags == ["option1", "option2"]
    end

    test "create_tactic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tactics.create_tactic(@invalid_attrs)
    end

    test "update_tactic/2 with valid data updates the tactic" do
      tactic = tactic_fixture()
      update_attrs = %{puzzle_id: "some updated puzzle_id", fen: "some updated fen", moves: "some updated moves", rating: 43, rating_deviation: 43, popularity: 43, nb_plays: 43, themes: ["option1"], game_url: "some updated game_url", opening_tags: ["option1"]}

      assert {:ok, %Tactic{} = tactic} = Tactics.update_tactic(tactic, update_attrs)
      assert tactic.puzzle_id == "some updated puzzle_id"
      assert tactic.fen == "some updated fen"
      assert tactic.moves == "some updated moves"
      assert tactic.rating == 43
      assert tactic.rating_deviation == 43
      assert tactic.popularity == 43
      assert tactic.nb_plays == 43
      assert tactic.themes == ["option1"]
      assert tactic.game_url == "some updated game_url"
      assert tactic.opening_tags == ["option1"]
    end

    test "update_tactic/2 with invalid data returns error changeset" do
      tactic = tactic_fixture()
      assert {:error, %Ecto.Changeset{}} = Tactics.update_tactic(tactic, @invalid_attrs)
      assert tactic == Tactics.get_tactic!(tactic.id)
    end

    test "delete_tactic/1 deletes the tactic" do
      tactic = tactic_fixture()
      assert {:ok, %Tactic{}} = Tactics.delete_tactic(tactic)
      assert_raise Ecto.NoResultsError, fn -> Tactics.get_tactic!(tactic.id) end
    end

    test "change_tactic/1 returns a tactic changeset" do
      tactic = tactic_fixture()
      assert %Ecto.Changeset{} = Tactics.change_tactic(tactic)
    end
  end
end
