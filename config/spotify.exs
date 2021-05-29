import Config

callback_domain =
  case config_env() do
    :dev -> "http://localhost:4000"
    :test -> "http://localhost:4000"
    :prod -> "https://not-a-concern.yet"
  end

config :spotify_ex,
  scopes: ["user-top-read", "playlist-read-private", "user-read-private", "user-read-email"],
  callback_url: "#{callback_domain}/authenticate"
