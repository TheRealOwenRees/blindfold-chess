defmodule BlindfoldChess do
  @moduledoc """
  BlindfoldChess keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def import_tactics, do: BlindfoldChess.Tactics.import_tactics()
end
