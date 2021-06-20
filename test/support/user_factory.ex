defmodule Songmate.UserFactory do
  def new(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Bass Wannabe",
        username: "hisongmate",
        credential: %{
          provider: :spotify,
          email: "hi@songmate.co",
          provider_uid: "hisongmate"
        }
      })
      |> Songmate.Accounts.UserService.create_user()

    user
  end
end
