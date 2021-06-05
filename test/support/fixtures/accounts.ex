defmodule Songmate.Fixtures.Accounts do
  use Agent
  @behaviour Songmate.Accounts

  # ----------------------------------------------
  # Arrange
  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(init_state) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def set_users(users) do
    update_state(:users, users)
  end

  def set_music_preferences(prefs) do
    update_state(:music_preferences, prefs)
  end

  # ----------------------------------------------
  # Act
  @impl Songmate.Accounts
  def list_users(except: excluded_user_id) do
    users = get_state(:users)

    if excluded_user_id do
      excluded = Enum.find(users, nil, &Map.get(&1, :id))
      users -- [excluded]
    else
      users
    end
  end

  @impl Songmate.Accounts
  def update_user(user, %{} = args) do
    update_state(:update_user, {user, args})
  end

  @impl Songmate.Accounts
  def list_music_preferences(user_ids: _user_ids) do
    [
      %{type: :artist, type_id: 1},
      %{type: :artist, type_id: 1},
      %{type: :artist, type_id: 1},
      %{type: :track, type_id: 1},
      %{type: :genre, type_id: 1}
    ]
  end

  @impl Songmate.Accounts
  def batch_upsert_music_preferences_for_user(_prefs, _user_id), do: nil

  # ----------------------------------------------
  # Assert

  def called_update_user(user) do
    case get_state(:update_user) do
      {result_user, _} -> result_user == user
      nil -> false
    end
  end

  # ----------------------------------------------
  # Util
  def update_state(key, val) do
    Agent.update(__MODULE__, &Map.put(&1, key, val))
  end

  def get_state(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
