# Songmate - Find your soulmate through songs!

## Roadmap

### Database Schema Redesign
- [ ] Design new schema.
  - [ ] STI for credentials?
  - [ ] indexes
- [ ] Create new tables.
- [ ] Adjust existing tables.
- [ ] Migrate existing data.
- [ ] Set up daily task to build user connections.

### Community Functionality
- [ ] Chatroom

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
  * has_one music_crendential
  * has_many connections
- Accounts.Crendential
  - provider:enum
  - email:string:unique
  - username:string:unique
  - expires_at:utc_datetime
  - token:string
  * belongs_to users
- Accounts.MusicProfile
  - top_tracks (can be chosen from playlists)
  - top_artists
  - top_genres
  * belongs_to users
- Communities.Connection
  - score
  - shared_artists
  - shared_tracks
  * belongs_to users

### Notes
- Connections table can be built daily (daily task)
- Users can choose to import music preferences from playlists
