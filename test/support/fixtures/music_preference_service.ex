defmodule Songmate.Fixtures.MusicPreferenceService do
  use Agent
  alias Songmate.Accounts.MusicPreferenceService
  @behaviour MusicPreferenceService

  # ----------------------------------------------
  # Act

  @impl MusicPreferenceService
  def get_all_by_user(_user_ids) do
    [
      %{type: :artist, type_id: 1},
      %{type: :artist, type_id: 1},
      %{type: :artist, type_id: 1},
      %{type: :track, type_id: 1},
      %{type: :genre, type_id: 1}
    ]
  end

  @impl MusicPreferenceService
  def batch_upsert_for_user(_prefs, _user_id), do: nil
end
