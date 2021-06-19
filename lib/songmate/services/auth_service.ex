defmodule Songmate.AuthService do
  alias Songmate.Accounts.UserRepo

  def validate_and_refresh_token(conn) do
    if Spotify.Authentication.tokens_present?(conn) do
      Spotify.Authentication.refresh(conn)
    end
  end

  def authorize_url do
    Spotify.Authorization.url()
  end

  def authenticate(conn, params) do
    Spotify.Authentication.authenticate(conn, params)
  end

  def fetch_user(conn) do
    {:ok, profile} = Spotify.Profile.me(conn)

    UserRepo.get_or_create_user(%{
      name: profile.display_name,
      avatar: List.first(profile.images)["url"],
      username: profile.id,
      credential: %{
        email: profile.email,
        provider_uid: profile.id,
        provider: :spotify
      }
    })
  end
end
