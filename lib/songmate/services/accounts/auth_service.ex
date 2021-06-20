defmodule Songmate.AuthService do
  alias Songmate.Accounts.UserService
  alias Songmate.Accounts.User
  @callback fetch_user_with_token(%Plug.Conn{}) :: nil | {%Plug.Conn{}, %User{}}

  def authorize_url do
    Spotify.Authorization.url()
  end

  def authenticate(conn, params) do
    Spotify.Authentication.authenticate(conn, params)
  end

  @spec fetch_user_with_token(%Plug.Conn{}) :: nil | {%Plug.Conn{}, %User{}}
  def fetch_user_with_token(conn) do
    with true <- Spotify.Authentication.tokens_present?(conn),
         {:ok, conn} <- Spotify.Authentication.refresh(conn),
         {:ok, profile} <- Spotify.Profile.me(conn),
         {:ok, user} <- UserService.get_or_create_user(format_user(profile)) do
      {conn, user}
    else
      _ -> nil
    end
  end

  defp format_user(profile) do
    %{
      name: profile.display_name,
      avatar: List.first(profile.images)["url"],
      username: profile.id,
      credential: %{
        email: profile.email,
        provider_uid: profile.id,
        provider: :spotify
      }
    }
  end
end
