import Config

# Configure your database
config :songmate, Songmate.Repo,
  username: "postgres",
  password: "postgres",
  database: "songmate_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :songmate, SongmateWeb.Endpoint,
  http: [port: 4002],
  server: false

config :songmate, :context,
  accounts: Songmate.Fixtures.Accounts,
  music: Songmate.Fixtures.Music,
  music_preferences: Songmate.Fixtures.MusicPreferences

# Print only warnings and errors during test
config :logger, level: :info
