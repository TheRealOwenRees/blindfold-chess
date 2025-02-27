# defmodule BlindfoldChess.ProfilesTest do
#   use BlindfoldChess.DataCase

#   alias BlindfoldChess.Profiles

#   describe "profiles" do
#     alias BlindfoldChess.Profiles.Profile

#     import BlindfoldChess.ProfilesFixtures

#     @invalid_attrs %{username: nil, full_name: nil}

#     test "list_profiles/0 returns all profiles" do
#       profile = profile_fixture()
#       assert Profiles.list_profiles() == [profile]
#     end

#     test "get_profile!/1 returns the profile with given id" do
#       profile = profile_fixture()
#       assert Profiles.get_profile!(profile.id) == profile
#     end

#     test "create_profile/1 with valid data creates a profile" do
#       valid_attrs = %{username: "some username", full_name: "some full_name"}

#       assert {:ok, %Profile{} = profile} = Profiles.create_profile(valid_attrs)
#       assert profile.username == "some username"
#       assert profile.full_name == "some full_name"
#     end

#     test "create_profile/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
#     end

#     test "update_profile/2 with valid data updates the profile" do
#       profile = profile_fixture()
#       update_attrs = %{username: "some updated username", full_name: "some updated full_name"}

#       assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, update_attrs)
#       assert profile.username == "some updated username"
#       assert profile.full_name == "some updated full_name"
#     end

#     test "update_profile/2 with invalid data returns error changeset" do
#       profile = profile_fixture()
#       assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
#       assert profile == Profiles.get_profile!(profile.id)
#     end

#     test "delete_profile/1 deletes the profile" do
#       profile = profile_fixture()
#       assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
#       assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
#     end

#     test "change_profile/1 returns a profile changeset" do
#       profile = profile_fixture()
#       assert %Ecto.Changeset{} = Profiles.change_profile(profile)
#     end
#   end
# end
