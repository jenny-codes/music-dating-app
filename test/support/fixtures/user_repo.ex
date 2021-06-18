defmodule Songmate.Fixtures.UserRepo do
  use Agent
  @behaviour Songmate.Accounts.UserRepo

  # ----------------------------------------------
  # Arrange
  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(init_state) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def set_users(users) do
    update_state(:users, users)
  end

  # ----------------------------------------------
  # Act
  @impl Songmate.Accounts.UserRepo
  def list_users(except: excluded_user_id) do
    users = get_state(:users)

    if excluded_user_id do
      excluded = Enum.find(users, nil, &Map.get(&1, :id))
      users -- [excluded]
    else
      users
    end
  end

  @impl Songmate.Accounts.UserRepo
  def update_user(user, %{} = args) do
    update_state(:update_user, {user, args})
  end

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
