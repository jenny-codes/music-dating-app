defmodule Songmate.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo

  alias Songmate.Accounts.{User, Credential, MusicPreference}

  @callback list_users(except: [non_neg_integer] | nil) :: [%{}]
  @callback update_user(%User{}, %{}) :: any

  @spec list_users(except: [non_neg_integer] | nil) :: [%User{}]
  def list_users() do
    Repo.all(User)
  end

  def list_users(except: except) do
    Repo.all(from(u in User, where: u.id not in ^except))
  end

  def get_or_create_user(user_attrs) do
    case Repo.get_by(Credential, user_attrs[:credential]) do
      nil ->
        create_user(user_attrs)

      credential ->
        {:ok, Repo.preload(credential, user: :credential).user}
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  @spec update_user(%User{}, %{}) :: any
  def update_user(%User{} = user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &User.changeset/2)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &User.changeset/2)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @callback list_music_preferences(user_ids: [non_neg_integer()]) :: nil | [%MusicPreference{}]
  @callback batch_upsert_music_preferences_for_user([%{}] | nil, integer()) :: any

  @spec list_music_preferences(user_ids: [non_neg_integer()]) :: nil | [%MusicPreference{}]
  def list_music_preferences(user_ids: user_ids) do
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
