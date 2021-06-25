defmodule Songmate.UserFactory do
  alias Songmate.MusicService
  alias Songmate.Accounts.UserService
  alias Songmate.Accounts.MusicPreferenceService

  def create_user(attrs \\ %{}) do
    salt = random_string()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "name#{salt}",
        username: "username#{salt}"
      })
      |> UserService.create_user()

    user
  end

  def create_user_with_music_preference(music_records) do
    user = create_user()

    music_records
    |> Enum.with_index(1)
    |> Enum.map(fn {record, idx} ->
      %{
        type: MusicService.type_for(record),
        type_id: record.id,
        rank: idx,
        user_id: user.id
      }
    end)
    |> MusicPreferenceService.batch_upsert_for_user(user.id)

    user
  end

  defp random_string do
    8
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
    |> String.downcase()
  end
end
