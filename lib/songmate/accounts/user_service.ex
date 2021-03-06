defmodule Songmate.Accounts.UserService do
  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.Accounts.{User, Credential}

  @callback list_users(except: [non_neg_integer] | nil) :: [%{}]
  @callback update_user(%User{}, %{}) :: any

  @spec list_users(except: [non_neg_integer] | nil) :: [%User{}]
  def list_users() do
    Repo.all(User)
  end

  def list_users(except: except) do
    Repo.all(from(u in User, where: u.id not in ^except))
  end

  def get_user(id) do
    Repo.get(User, id)
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

  @spec delete_user(%User{}) :: any
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
