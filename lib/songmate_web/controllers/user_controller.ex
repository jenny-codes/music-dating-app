defmodule SongmateWeb.UserController do
  use SongmateWeb, :controller

  alias Songmate.UseCase.{
    GetUserMusicRecords,
    FindTopMatch,
    FindSharedMusic
  }

  alias Songmate.AccountService

  plug(SongmateWeb.SyncUserInfoPlug)

  def index(conn, _params) do
    music_records = GetUserMusicRecords.call(conn.assigns.current_user.id)

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

    with target_username when not is_nil(target_username) <- params["user"],
         {:ok, target_user} <- AccountService.get_user_by(username: target_username),
         target_user when target_user.id != current_user.id <- target_user do
      shared = FindSharedMusic.call(current_user.id, target_user.id)

      render(
        conn,
        "peek.html",
        current_user_name: current_user.name,
        target_user_name: target_user.name,
        shared_artists: Enum.map(shared[:artist], & &1.name),
        shared_tracks: Enum.map(shared[:track], & &1.name),
        shared_genres: Enum.map(shared[:genre], & &1.name)
      )
    else
      _ -> redirect(conn, to: "/")
    end
  end

  def explore(conn, _params) do
    user = conn.assigns.current_user

    %{user: user, shared: shared} = FindTopMatch.call(user.id)

    render(
      conn,
      "explore.html",
      shared_artists: Enum.map(shared[:artist], & &1.name),
      shared_tracks: Enum.map(shared[:track], & &1.name),
      shared_genres: Enum.map(shared[:genre], & &1.name),
      match_user: user
    )
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end
end
