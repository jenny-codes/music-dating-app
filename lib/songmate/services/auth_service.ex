defmodule Songmate.AuthService do
  @type user :: %{
          email: String.t(),
          username: String.t(),
          avatar_url: String.t(),
          display_name: String.t()
        }

  def validate_and_refresh_token(conn) do
    with true <- Spotify.Authentication.tokens_present?(conn),
         {:ok, conn} <- Spotify.Authentication.refresh(conn) do
      {:ok, conn}
    end
  end

  def authorize_url do
    Spotify.Authorization.url()
  end

  def authenticate(conn, params) do
    Spotify.Authentication.authenticate(conn, params)
  end

  @spec fetch_user_info(%{__struct__: Plug.Conn}) :: user()
  def fetch_user_info(conn) do
    {:ok, profile} = Spotify.Profile.me(conn)

    %{
      email: profile.email,
      username: profile.id,
      avatar_url: List.first(profile.images)["url"],
      display_name: profile.display_name
    }
  end
end
