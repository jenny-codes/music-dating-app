defmodule SongmateWeb.SyncUserInfoPlug do
  alias Songmate.UseCase.ImportMusicPreference

  @one_week_in_seconds 7 * 24 * 60 * 60
  def init(options) do
    options
  end

  def call(conn, opts) do
    importer = opts[:importer] || ImportMusicPreference
    user = conn.assigns[:current_user]
    if should_update(user), do: importer.call(user, conn)

    conn
  end

  defp should_update(user) do
    if user.preferences_updated_at do
      last_updated_duration =
        NaiveDateTime.diff(
          NaiveDateTime.local_now(),
          user.preferences_updated_at
        )

      last_updated_duration > @one_week_in_seconds
    else
      true
    end
  end
end
