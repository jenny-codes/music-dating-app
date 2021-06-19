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
    user_info = fetch_user_profile(conn)

    UserRepo.get_or_create_user(%{
      name: user_info[:display_name],
      avatar: user_info[:avatar_url],
      username: user_info[:username],
      credential: %{
        email: user_info[:email],
        provider_uid: user_info[:username],
        provider: :spotify
      }
    })
  end

  def fetch_user_profile(conn) do
    {:ok, profile} = Spotify.Profile.me(conn)

    %{
      email: profile.email,
      username: profile.id,
      avatar_url: List.first(profile.images)["url"],
      display_name: profile.display_name
    }
  end
end
