defmodule Songmate.Accounts.MusicPreferenceService do
  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.Accounts.MusicPreference

  @callback get_all_by_user([non_neg_integer()]) :: [%MusicPreference{}]
  @callback batch_upsert_music_preferences_for_user([%{}] | nil, integer()) :: any

  def get_all_by_user(user_ids) do
    Repo.all(from(pref in MusicPreference, where: pref.user_id in ^user_ids))
  end

  @spec batch_upsert_music_preferences_for_user([%{}] | nil, integer()) :: any
  def batch_upsert_music_preferences_for_user(nil, _user_id), do: nil
  def batch_upsert_music_preferences_for_user([], _user_id), do: nil

  def batch_upsert_music_preferences_for_user(prefs, user_id) do
    Repo.delete_all(from(pref in MusicPreference, where: pref.user_id == ^user_id))
    Repo.insert_all(MusicPreference, prefs)
  end
end
