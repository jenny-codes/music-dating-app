# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Songmate.Repo.insert!(%Songmate.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Songmate.Accounts.{UserService, MusicPreferenceService}
alias Songmate.Music.{ArtistService, TrackService}

# --------------------------------------------------------
# Music.Artist

ArtistService.create_artist(%{
  name: "fun.",
  popularity: 72,
  spotify_id: "5nCi3BB41mBaMH9gfr6Su0",
  genres: [
    %{name: "baroque pop"},
    %{name: "metropopolis"},
    %{name: "modern rock"},
    %{name: "pop"},
    %{name: "pop rock"}
  ]
})

ArtistService.create_artist(%{
  name: "The National",
  popularity: 71,
  spotify_id: "2cCUtGK9sDU2EoElnk0GNB",
  genres: [
    %{name: "chamber pop"},
    %{name: "indie rock"},
    %{name: "modern rock"}
  ]
})

ArtistService.create_artist(%{
  name: "Vampire Weekend",
  popularity: 73,
  spotify_id: "5BvJzeQpmsdsFp4HGUYUEx",
  genres: [
    %{name: "baroque pop"},
    %{name: "indie pop"},
    %{name: "modern rock"}
  ]
})

ArtistService.create_artist(%{
  name: "Alt-J",
  popularity: 76,
  spotify_id: "3XHO7cRUPCLOr6jwp8vsx5",
  genres: [
    %{name: "indie rock"},
    %{name: "modern rock"}
  ]
})

ArtistService.create_artist(%{
  name: "Coldplay",
  popularity: 89,
  spotify_id: "4gzpq5DPGxSnKTe4SA8HAU",
  genres: [
    %{name: "permanent wave"},
    %{name: "pop"}
  ]
})

# --------------------------------------------------------
# Music.Track

TrackService.create_track(%{
  isrc: "TWAE31801542",
  name: "小夜曲",
  popularity: 13,
  spotify_id: "3NQZXlcclUtUG1GFtpf9dB",
  artists: [
    %{name: "鹿先森乐队", spotify_id: "4SklOYXOJe2H6R1Vz2gc0F"}
  ]
})

TrackService.create_track(%{
  isrc: "CNA791600507",
  name: "我们拥抱亲吻相爱的人",
  popularity: 12,
  spotify_id: "1xEmedKKoZiDWXHMjDoIZb",
  artists: [
    %{name: "鹿先森乐队", spotify_id: "4SklOYXOJe2H6R1Vz2gc0F"}
  ]
})

TrackService.create_track(%{
  isrc: "USMRG0467010",
  name: "Rebellion (Lies)",
  popularity: 65,
  spotify_id: "0xOeB16JDbBJBJKSdHbElT",
  artists: [
    %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
  ]
})

TrackService.create_track(%{
  isrc: "TWA471204005",
  name: "如何 - Through Our Lives",
  popularity: 33,
  spotify_id: "4wg3QfnD1S87eTRQ7K4yc9",
  artists: [
    %{name: "Deserts Chang", spotify_id: "7v9Il42LvvTeSfmf1bwfNx"}
  ]
})

TrackService.create_track(%{
  isrc: "GBAFL1000103",
  name: "England",
  popularity: 46,
  spotify_id: "68KlkUNTX8gRp7TrM1Ut5u",
  artists: [
    %{name: "The National", spotify_id: "2cCUtGK9sDU2EoElnk0GNB"}
  ]
})

# --------------------------------------------------------
# Accounts

{:ok, user1} = UserService.get_or_create_user(%{
  name: "French toast",
  username: "french-toast",
  credential: %{provider: :spotify, email: "hi@songmate", provider_uid: "french-toast"}
})

{:ok, user2} = UserService.get_or_create_user(%{
  name: "Whisky Egg",
  username: "whisky-egg",
  credential: %{provider: :spotify, email: "egg@songmate", provider_uid: "whisky-egg"}
})

user1_prefs = [
  %{rank: 1, type: :artist, type_id: 11, user_id: user1.id},
  %{rank: 2, type: :artist, type_id: 12, user_id: user1.id},
  %{rank: 3, type: :artist, type_id: 13, user_id: user1.id},
  %{rank: 4, type: :artist, type_id: 14, user_id: user1.id},
  %{rank: 5, type: :artist, type_id: 15, user_id: user1.id},
  %{rank: 6, type: :artist, type_id: 6, user_id: user1.id},
  %{rank: 7, type: :artist, type_id: 17, user_id: user1.id},
  %{rank: 8, type: :artist, type_id: 18, user_id: user1.id},
  %{rank: 9, type: :artist, type_id: 19, user_id: user1.id},
  %{rank: 10, type: :artist, type_id: 20, user_id: user1.id},
  %{rank: 11, type: :artist, type_id: 21, user_id: user1.id},
  %{rank: 1, type: :track, type_id: 6, user_id: user1.id},
  %{rank: 2, type: :track, type_id: 7, user_id: user1.id},
  %{rank: 3, type: :track, type_id: 8, user_id: user1.id},
  %{rank: 4, type: :track, type_id: 9, user_id: user1.id},
  %{rank: 5, type: :track, type_id: 10, user_id: user1.id},
  %{rank: 6, type: :track, type_id: 11, user_id: user1.id},
  %{rank: 7, type: :track, type_id: 12, user_id: user1.id},
  %{rank: 8, type: :track, type_id: 13, user_id: user1.id},
  %{rank: 9, type: :track, type_id: 14, user_id: user1.id},
  %{rank: 10, type: :track, type_id: 15, user_id: user1.id},
  %{rank: 1, type: :genre, type_id: 5, user_id: user1.id},
  %{rank: 2, type: :genre, type_id: 27, user_id: user1.id},
  %{rank: 3, type: :genre, type_id: 28, user_id: user1.id},
  %{rank: 4, type: :genre, type_id: 29, user_id: user1.id},
  %{rank: 5, type: :genre, type_id: 30, user_id: user1.id},
  %{rank: 6, type: :genre, type_id: 31, user_id: user1.id},
  %{rank: 7, type: :genre, type_id: 32, user_id: user1.id},
  %{rank: 8, type: :genre, type_id: 33, user_id: user1.id},
  %{rank: 9, type: :genre, type_id: 34, user_id: user1.id},
  %{rank: 10, type: :genre, type_id: 35, user_id: user1.id}
]

user2_prefs = [
  %{rank: 2, type: :artist, type_id: 4, user_id: user2.id},
  %{rank: 3, type: :artist, type_id: 8, user_id: user2.id},
  %{rank: 4, type: :artist, type_id: 24, user_id: user2.id},
  %{rank: 5, type: :artist, type_id: 25, user_id: user2.id},
  %{rank: 6, type: :artist, type_id: 26, user_id: user2.id},
  %{rank: 7, type: :artist, type_id: 27, user_id: user2.id},
  %{rank: 8, type: :artist, type_id: 28, user_id: user2.id},
  %{rank: 9, type: :artist, type_id: 29, user_id: user2.id},
  %{rank: 10, type: :artist, type_id: 30, user_id: user2.id},
  %{rank: 1, type: :artist, type_id: 31, user_id: user2.id},
  %{rank: 1, type: :track, type_id: 16, user_id: user2.id},
  %{rank: 2, type: :track, type_id: 17, user_id: user2.id},
  %{rank: 3, type: :track, type_id: 18, user_id: user2.id},
  %{rank: 4, type: :track, type_id: 19, user_id: user2.id},
  %{rank: 5, type: :track, type_id: 20, user_id: user2.id},
  %{rank: 6, type: :track, type_id: 21, user_id: user2.id},
  %{rank: 7, type: :track, type_id: 22, user_id: user2.id},
  %{rank: 8, type: :track, type_id: 23, user_id: user2.id},
  %{rank: 9, type: :track, type_id: 24, user_id: user2.id},
  %{rank: 10, type: :track, type_id: 25, user_id: user2.id},
  %{rank: 1, type: :genre, type_id: 10, user_id: user2.id},
  %{rank: 2, type: :genre, type_id: 7, user_id: user2.id},
  %{rank: 3, type: :genre, type_id: 3, user_id: user2.id},
  %{rank: 4, type: :genre, type_id: 19, user_id: user2.id},
  %{rank: 5, type: :genre, type_id: 4, user_id: user2.id},
  %{rank: 6, type: :genre, type_id: 21, user_id: user2.id},
  %{rank: 7, type: :genre, type_id: 22, user_id: user2.id},
  %{rank: 8, type: :genre, type_id: 23, user_id: user2.id},
  %{rank: 9, type: :genre, type_id: 24, user_id: user2.id},
  %{rank: 10, type: :genre, type_id: 25, user_id: user2.id}
]


MusicPreferenceService.batch_upsert_music_preferences_for_user(user1_prefs, user1.id)
MusicPreferenceService.batch_upsert_music_preferences_for_user(user2_prefs, user2.id)
