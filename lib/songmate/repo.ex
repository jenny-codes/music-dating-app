defmodule Songmate.Repo do
  use Ecto.Repo,
    otp_app: :songmate,
    adapter: Ecto.Adapters.Postgres
end
