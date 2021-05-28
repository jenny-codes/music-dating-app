defmodule Songmate.CommunityTest do
  use Songmate.DataCase

  alias Songmate.Community

  describe "connections" do
    alias Songmate.Community.Connection

    @valid_attrs %{score: 42, shared_preferences: %{}}
    @update_attrs %{score: 43, shared_preferences: %{}}
    @invalid_attrs %{score: nil, shared_preferences: nil}

    def connection_fixture(attrs \\ %{}) do
      {:ok, connection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Community.create_connection()

      connection
    end

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert Community.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert Community.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      attrs = %{
        score: 100,
        music_profiles: [
          %{user: valid_user_attrs()},
          %{user: valid_2nd_user_attrs()}
        ]
      }

      assert {:ok, %Connection{} = connection} = Community.create_connection(attrs)
      connection = Repo.preload(connection, music_profiles: [:user])
      assert connection.score == 100
      assert length(connection.music_profiles) == 2
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Community.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()

      assert {:ok, %Connection{} = connection} =
               Community.update_connection(connection, @update_attrs)

      assert connection.score == 43
      assert connection.shared_preferences == %{}
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()
      assert {:error, %Ecto.Changeset{}} = Community.update_connection(connection, @invalid_attrs)
      assert connection == Community.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = Community.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> Community.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = Community.change_connection(connection)
    end
  end
end
