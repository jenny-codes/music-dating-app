# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

import "config.secret.exs"
import "spotify.secret.exs"

# General application configuration
use Mix.Config

config :spotumwise,
  ecto_repos: [Spotumwise.Repo]

# Configures the endpoint
config :spotumwise, SpotumwiseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dMQSUfyVJZ1LxrMmblOwdBWucdA+pJpztcC/FTQBbmAtgX0ABueTHGxr+dnj6zov",
  render_errors: [view: SpotumwiseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Spotumwise.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "HPVqdshP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
