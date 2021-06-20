defmodule Songmate.Fixtures.MusicPreferenceService do
  use Agent
  alias Songmate.Accounts.MusicPreferenceService
  @behaviour MusicPreferenceService

  # ----------------------------------------------
  # Arrange
  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(init_state) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def set_music_preferences(prefs) do
    update_state(:music_preferences, prefs)
  end

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

  # ----------------------------------------------
  # Util
  def update_state(key, val) do
    Agent.update(__MODULE__, &Map.put(&1, key, val))
  end

  # def get_state(key) do
  #   Agent.get(__MODULE__, &Map.get(&1, key))
  # end
end
