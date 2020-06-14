# Songmate - Find your soulmate through songs!

## Roadmap

### Database Schema Redesign
- [x] Design new schema.
  - [x] STI for credentials?
  - [x] indexes
- [x] Create new tables.
- [x] Build new table relations.
  - [x] Accounts
  - [x] Music
  - [x] MusicProfile
  - [x] Community
- [x] Build join table behaviors.
- [ ] Migrate existing data.
- [ ] Adjust auth permissions.
- [ ] Set up tasks to do daily updates.

### Deploy
- [x] Update UI.
- [ ] Set up GCP account.
- [ ] Set up CI and code style check.

### Community Functionality
- [ ] Profile edit page
- [ ] Chatroom

### Matching Algorithm
- [ ] Reexamine existing weights on tracks, artists and genres.
- [ ] New dimensions: popularity.
- [ ] New dimensions: track & artist rank.
- [ ] New dimensions: Spotify track audio features.

## DB Schema
### Legacy
- User
  - name
  - bio
  - top_matches
  - top_tracks
  - top_artists
  - top_genres

### New
- Accounts.User
  - name:string
  - bio:text
  - avatar:string(of url)
  * has_one credential
  * has_many connections
- Accounts.Crendential
  - provider:enum
  - email:string:unique
  - username:string:unique
  - expires_at:utc_datetime
  - token:string
  * belongs_to users

- Music.Track
  - isrc
  - spotify_id
  - name
  - popularity
  * many_to_many artists
  * many_to_many track_preferences
- Music.Artist
  - spotify_id
  - name
  - popularity
  * many_to_many tracks
  * many_to_many genres
  * many_to_many artist_preferences
- Music.Genre
  - name
  - many_to_many artists

- MusicProfile.Profile
  * belongs_to Accounts.user
  * has_many track_preferences
  * has_many artist_preferences
  * has_many genre_preferences
  * many_to_many tracks, through track_preferences
  * many_to_many artists, through artists_preferences
- MusicProfile.TrackPreference
  - rank
  * belongs_to user_profile
  * belongs_to track
- MusicProfile.ArtistPreference
  - rank
  * belongs_to user_profile
  * belongs_to artist

- Community.Connection
  - score
  - shared_artists
  - shared_tracks
  - shared_genres
  * belongs_to users
