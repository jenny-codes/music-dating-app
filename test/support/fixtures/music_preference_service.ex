defmodule Songmate.Fixtures.MusicPreferenceService do
  use Agent
  alias Songmate.Accounts.MusicPreferenceService
  @behaviour MusicPreferenceService

  # ----------------------------------------------
  # Act

  @impl MusicPreferenceService
  def list_music_preferences(user_ids: _user_ids) do
    [
      %{type: :artist, type_id: 1},
      %{type: :artist, type_id: 1},
      %{type: :artist, type_id: 1},
      %{type: :track, type_id: 1},
      %{type: :genre, type_id: 1}
    ]
  end

  @impl MusicPreferenceService
  def batch_upsert_music_preferences_for_user(_prefs, _user_id), do: nil
end
