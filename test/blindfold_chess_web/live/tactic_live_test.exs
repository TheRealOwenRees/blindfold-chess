defmodule BlindfoldChessWeb.TacticLiveTest do
  use BlindfoldChessWeb.ConnCase

  import Phoenix.LiveViewTest
  import BlindfoldChess.TacticsFixtures

  @create_attrs %{puzzle_id: "some puzzle_id", fen: "some fen", moves: "some moves", rating: 42, rating_deviation: 42, popularity: 42, nb_plays: 42, themes: ["option1", "option2"], game_url: "some game_url", opening_tags: ["option1", "option2"]}
  @update_attrs %{puzzle_id: "some updated puzzle_id", fen: "some updated fen", moves: "some updated moves", rating: 43, rating_deviation: 43, popularity: 43, nb_plays: 43, themes: ["option1"], game_url: "some updated game_url", opening_tags: ["option1"]}
  @invalid_attrs %{puzzle_id: nil, fen: nil, moves: nil, rating: nil, rating_deviation: nil, popularity: nil, nb_plays: nil, themes: [], game_url: nil, opening_tags: []}

  defp create_tactic(_) do
    tactic = tactic_fixture()
    %{tactic: tactic}
  end

  describe "Index" do
    setup [:create_tactic]

    test "lists all tactics", %{conn: conn, tactic: tactic} do
      {:ok, _index_live, html} = live(conn, ~p"/tactics")

      assert html =~ "Listing Tactics"
      assert html =~ tactic.puzzle_id
    end

    test "saves new tactic", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tactics")

      assert index_live |> element("a", "New Tactic") |> render_click() =~
               "New Tactic"

      assert_patch(index_live, ~p"/tactics/new")

      assert index_live
             |> form("#tactic-form", tactic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tactic-form", tactic: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tactics")

      html = render(index_live)
      assert html =~ "Tactic created successfully"
      assert html =~ "some puzzle_id"
    end

    test "updates tactic in listing", %{conn: conn, tactic: tactic} do
      {:ok, index_live, _html} = live(conn, ~p"/tactics")

      assert index_live |> element("#tactics-#{tactic.id} a", "Edit") |> render_click() =~
               "Edit Tactic"

      assert_patch(index_live, ~p"/tactics/#{tactic}/edit")

      assert index_live
             |> form("#tactic-form", tactic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tactic-form", tactic: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tactics")

      html = render(index_live)
      assert html =~ "Tactic updated successfully"
      assert html =~ "some updated puzzle_id"
    end

    test "deletes tactic in listing", %{conn: conn, tactic: tactic} do
      {:ok, index_live, _html} = live(conn, ~p"/tactics")

      assert index_live |> element("#tactics-#{tactic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tactics-#{tactic.id}")
    end
  end

  describe "Show" do
    setup [:create_tactic]

    test "displays tactic", %{conn: conn, tactic: tactic} do
      {:ok, _show_live, html} = live(conn, ~p"/tactics/#{tactic}")

      assert html =~ "Show Tactic"
      assert html =~ tactic.puzzle_id
    end

    test "updates tactic within modal", %{conn: conn, tactic: tactic} do
      {:ok, show_live, _html} = live(conn, ~p"/tactics/#{tactic}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tactic"

      assert_patch(show_live, ~p"/tactics/#{tactic}/show/edit")

      assert show_live
             |> form("#tactic-form", tactic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#tactic-form", tactic: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tactics/#{tactic}")

      html = render(show_live)
      assert html =~ "Tactic updated successfully"
      assert html =~ "some updated puzzle_id"
    end
  end
end
