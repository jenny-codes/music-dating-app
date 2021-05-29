# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :songmate,
  ecto_repos: [Songmate.Repo]

# Configures the endpoint
config :songmate, SongmateWeb.Endpoint,
  secret_key_base: "dMQSUfyVJZ1LxrMmblOwdBWucdA+pJpztcC/FTQBbmAtgX0ABueTHGxr+dnj6zov",
  render_errors: [view: SongmateWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Songmate.PubSub,
  live_view: [signing_salt: "HPVqdshP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

import_config "secret.exs"
import_config "spotify.exs"
