use Mix.Config

config :spotify_ex,
  scopes: ["user-top-read", "playlist-read-private", "user-read-private", "user-read-email"],
  callback_url: "https://3b53a0fb.ngrok.io/authenticate"
