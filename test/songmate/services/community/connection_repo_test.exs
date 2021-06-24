defmodule Songmate.ConnectionServiceTest do
  use Songmate.DataCase, async: true

  alias Songmate.Community.ConnectionService

  describe "connections" do
    alias Songmate.Community.Connection

    @valid_attrs %{score: 42, shared_preferences: %{}}
    @update_attrs %{score: 43, shared_preferences: %{}}
    @invalid_attrs %{score: nil, shared_preferences: nil}

    def connection_fixture(attrs \\ %{}) do
      {:ok, connection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ConnectionService.create_connection()

      connection
    end

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert ConnectionService.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert ConnectionService.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      attrs = %{
        score: 100,
        users: [
          valid_user_attrs(),
          valid_2nd_user_attrs()
        ]
      }

      assert {:ok, %Connection{} = connection} = ConnectionService.create_connection(attrs)
      connection = Repo.preload(connection, :users)
      assert connection.score == 100
      assert length(connection.users) == 2
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ConnectionService.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()

      assert {:ok, %Connection{} = connection} =
               ConnectionService.update_connection(connection, @update_attrs)

      assert connection.score == 43
      assert connection.shared_preferences == %{}
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ConnectionService.update_connection(connection, @invalid_attrs)

      assert connection == ConnectionService.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = ConnectionService.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> ConnectionService.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = ConnectionService.change_connection(connection)
    end
  end

  def valid_user_attrs do
    %{
      name: "Bass Wannabe",
      username: "hisongmate",
      bio: "Some nights I stay up cashing in my bad luck",
      avatar: "some-link-to-an-image",
      credential: %{
        provider: :spotify,
        email: "hi@songmate.co",
        provider_uid: "hisongmate"
      }
    }
  end

  def valid_2nd_user_attrs do
    %{
      name: "Spotify Rocks",
      username: "spotify-rocks",
      bio: "ugh",
      credential: %{
        provider: :spotify,
        email: "spotify@rocks",
        provider_uid: "spotify-rocks"
      }
    }
  end
end
