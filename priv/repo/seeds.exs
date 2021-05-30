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

alias Songmate.Accounts
alias Songmate.Music

# --------------------------------------------------------
# Accounts
Accounts.create_user(%{
  name: "Spotify Rocks",
  bio: "blanking",
  credential: %{provider: :spotify, email: "fake-email", username: "fake-spotify-id"}
})

Accounts.create_user(%{
  name: "I Rocks More",
  bio: "ugh",
  credential: %{provider: :spotify, email: "fake-email-2", username: "fake-spotify-id-2"}
})


# --------------------------------------------------------
# Music.Artist

Music.create_artist(%{
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

Music.create_artist(%{
  name: "The National",
  popularity: 71,
  spotify_id: "2cCUtGK9sDU2EoElnk0GNB",
  genres: [
    %{name: "chamber pop"},
    %{name: "indie rock"},
    %{name: "modern rock"}
  ]
})

Music.create_artist(%{
  name: "Vampire Weekend",
  popularity: 73,
  spotify_id: "5BvJzeQpmsdsFp4HGUYUEx",
  genres: [
    %{name: "baroque pop"},
    %{name: "indie pop"},
    %{name: "modern rock"}
  ]
})

Music.create_artist(%{
  name: "Alt-J",
  popularity: 76,
  spotify_id: "3XHO7cRUPCLOr6jwp8vsx5",
  genres: [
    %{name: "indie rock"},
    %{name: "modern rock"}
  ]
})

Music.create_artist(%{
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

Music.create_track(%{
  isrc: "TWAE31801542",
  name: "小夜曲",
  popularity: 13,
  spotify_id: "3NQZXlcclUtUG1GFtpf9dB",
  artists: [
    %{name: "鹿先森乐队", spotify_id: "4SklOYXOJe2H6R1Vz2gc0F"}
  ]
})

Music.create_track(%{
  isrc: "CNA791600507",
  name: "我们拥抱亲吻相爱的人",
  popularity: 12,
  spotify_id: "1xEmedKKoZiDWXHMjDoIZb",
  artists: [
    %{name: "鹿先森乐队", spotify_id: "4SklOYXOJe2H6R1Vz2gc0F"}
  ]
})

Music.create_track(%{
  isrc: "USMRG0467010",
  name: "Rebellion (Lies)",
  popularity: 65,
  spotify_id: "0xOeB16JDbBJBJKSdHbElT",
  artists: [
    %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
  ]
})

Music.create_track(%{
  isrc: "TWA471204005",
  name: "如何 - Through Our Lives",
  popularity: 33,
  spotify_id: "4wg3QfnD1S87eTRQ7K4yc9",
  artists: [
    %{name: "Deserts Chang", spotify_id: "7v9Il42LvvTeSfmf1bwfNx"}
  ]
})

Music.create_track(%{
  isrc: "GBAFL1000103",
  name: "England",
  popularity: 46,
  spotify_id: "68KlkUNTX8gRp7TrM1Ut5u",
  artists: [
    %{name: "The National", spotify_id: "2cCUtGK9sDU2EoElnk0GNB"}
  ]
})
