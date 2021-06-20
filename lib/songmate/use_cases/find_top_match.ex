defmodule Songmate.UseCase.FindTopMatch do
  alias Songmate.Accounts.User
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.Accounts.UserService
  alias Songmate.UseCase.GenerateMatchData

  @type music_type :: %{artist: [%Artist{}], track: [%Track{}], genre: [%Genre{}]}

  @user_service Application.compile_env(
                  :songmate,
                  [:services, :user_service],
                  UserService
                )

  @spec call(%User{}) :: %{user: %User{}, score: integer(), shared: music_type()}
  def call(user) do
    candidates = @user_service.list_users(except: [user.id])

    candidates
    |> Enum.map(& &1.id)
    |> Enum.map(&GenerateMatchData.call(user.id, &1))
    |> Enum.zip(candidates)
    |> Enum.map(fn {data, user} -> Map.put(data, :user, user) end)
    |> Enum.max_by(&Map.get(&1, :score))
  end
end
