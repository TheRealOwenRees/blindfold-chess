# defmodule BlindfoldChess.ProfilesFixtures do
#   @moduledoc """
#   This module defines test helpers for creating
#   entities via the `BlindfoldChess.Profiles` context.
#   """

#   @doc """
#   Generate a profile.
#   """
#   def profile_fixture(attrs \\ %{}) do
#     {:ok, profile} =
#       attrs
#       |> Enum.into(%{
#         full_name: "some full_name",
#         username: "some username"
#       })
#       |> BlindfoldChess.Profiles.create_profile()

#     profile
#   end
# end
