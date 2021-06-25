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

config :songmate, :services,
  music_preference_service: Songmate.Fixtures.MusicPreferenceService,
  artist_service: Songmate.Fixtures.ArtistService,
  track_service: Songmate.Fixtures.TrackService,
  genre_service: Songmate.Fixtures.GenreService,
  auth_service: Songmate.Mock.AuthService,
  spotify_service: Songmate.Fixtures.SpotifyService

config :songmate, :use_cases, import_music_preference: Songmate.Mock.ImportMusicPreference

# Print only warnings and errors during test
config :logger, level: :info
