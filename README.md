# Songmate - Find your soulmate through songs!

## Roadmap

### Database Schema Redesign
- [ ] Design new schema.
  - [ ] STI for credentials?
  - [ ] indexes
- [ ] Create new tables.
- [ ] Adjust existing tables.
- [ ] Migrate existing data.
- [ ] App-layer logic
  - [ ] Adjust auth permissions.
  - [ ] Set up daily tasks.

### Community Functionality
- [ ] Chatroom

### Matching Algorithm Redesign
- [ ] Reexamine existing weights on tracks, artists and genres.
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

- Profile.MusicProfile
  * belongs_to user
  * has_many track_preferences
  * has_many artist_preferences
  * has_many genre_preferences
  * many_to_many tracks, through track_preferences
  * many_to_many artists, through artists_preferences
- Profile.TrackPreference
  - rank
  * belongs_to user_profile
  * belongs_to track
- Profile.ArtistPreference
  - rank
  * belongs_to user_profile
  * belongs_to artist

- Communities.Connection
  - score
  - shared_artists
  - shared_tracks
  * belongs_to users
