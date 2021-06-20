defmodule SongmateWeb.UserController do
  use SongmateWeb, :controller
  alias Songmate.UseCase.{FindTopMatch, GenerateMatchData, ImportMusicPreference}
  alias Songmate.MusicService
  alias Songmate.AccountService
  alias Songmate.Accounts.MusicPreferenceService

  @one_week_in_seconds 7 * 24 * 60 * 60

  def index(conn, _params) do
    user = conn.assigns.current_user

    if should_update(user), do: ImportMusicPreference.call(user, conn)

    music_records =
      MusicPreferenceService.list_music_preferences(user_ids: [user.id])
      |> Enum.group_by(& &1.type, & &1.type_id)
      |> MusicService.batch_get_music_records()

    render(
      conn,
      "index.html",
      top_artists: Enum.map(music_records[:artist], & &1.name),
      top_tracks: Enum.map(music_records[:track], & &1.name),
      top_genres: Enum.map(music_records[:genre], & &1.name)
    )
  end

  def peek(conn, params) do
    current_user = conn.assigns.current_user

    with username when not is_nil(username) and username != current_user.username <-
           params["user"],
         {:ok, target_user} <- AccountService.get_user_by(username: username) do
      %{score: score, shared: shared} = GenerateMatchData.call(current_user.id, target_user.id)

      music_records = MusicService.batch_get_music_records(shared)

      render(
        conn,
        "peek.html",
        current_user_name: current_user.name,
        target_user_name: target_user.name,
        score: score,
        shared_artists: Enum.map(music_records[:artist], & &1.name),
        shared_tracks: Enum.map(music_records[:track], & &1.name),
        shared_genres: Enum.map(music_records[:genre], & &1.name)
      )
    else
      _ ->
        redirect(conn, to: "/")
    end
  end

  def explore(conn, _params) do
    user = conn.assigns.current_user

    if should_update(user), do: ImportMusicPreference.call(user, conn)

    %{user: user, score: score, shared: shared} = FindTopMatch.call(user)
    music_records = MusicService.batch_get_music_records(shared)

    render(
      conn,
      "explore.html",
      shared_artists: Enum.map(music_records[:artist], & &1.name),
      shared_tracks: Enum.map(music_records[:track], & &1.name),
      shared_genres: Enum.map(music_records[:genre], & &1.name),
      match_user: user,
      score: score
    )
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end

  defp should_update(user) do
    !user.preferences_updated_at ||
      NaiveDateTime.diff(
        NaiveDateTime.local_now(),
        user.preferences_updated_at
      ) > @one_week_in_seconds
  end
end
