defmodule Songmate.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Songmate.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Songmate.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Songmate.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Songmate.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Songmate.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(
      changeset,
      fn {message, opts} ->
        Regex.replace(
          ~r"%{(\w+)}",
          message,
          fn _, key ->
            opts
            |> Keyword.get(String.to_existing_atom(key), key)
            |> to_string()
          end
        )
      end
    )
  end

  # -----------------------------------------------------------------------
  # Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(valid_user_attrs())
      |> Songmate.Accounts.create_user()

    user
  end

  def valid_user_attrs do
    %{
      name: "Bass Wannabe",
      bio: "Some nights I stay up cashing in my bad luck",
      avatar: "some-link-to-an-image",
      credential: %{
        provider: :spotify,
        email: "hi@songmate.co",
        username: "hisongmate"
      }
    }
  end

  def valid_2nd_user_attrs do
    %{
      name: "Spotify Rocks",
      bio: "ugh",
      credential: %{
        provider: :spotify,
        email: "spotify@rocks",
        username: "spotify-rocks"
      }
    }
  end

  # -----------------------------------------------------------------------
  # Music

  def valid_track_attrs do
    %{
      isrc: "USMRG0467010",
      name: "Rebellion (Lies)",
      popularity: 65,
      spotify_id: "0xOeB16JDbBJBJKSdHbElT"
    }
  end

  def valid_artist_attrs do
    %{
      name: "9m88",
      popularity: 53,
      spotify_id: "4PjY2961rc0MHE9zHYWEnH"
    }
  end

  def valid_genre_attrs do
    %{name: "Modern Rock"}
  end

  # -----------------------------------------------------------------------
  # MusicPreferences

  def valid_artist_preference_attrs do
    %{
      rank: 1,
      artist: valid_artist_attrs()
    }
  end

  def valid_track_preference_attrs do
    %{
      rank: 2,
      artist: valid_track_attrs()
    }
  end

  def valid_genre_preference_attrs do
    %{
      rank: 3,
      artist: valid_genre_attrs()
    }
  end
end
