defmodule Songmate.AccountService do
  alias Songmate.Accounts.User

  def get_user_by(condition) do
    case Songmate.Repo.get_by(User, condition) do
      nil -> {:error, "Cannot find user record"}
      user -> {:ok, user}
    end
  end
end
