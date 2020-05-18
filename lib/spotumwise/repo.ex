defmodule Spotumwise.Repo do
  use Ecto.Repo,
    otp_app: :spotumwise,
    adapter: Ecto.Adapters.Postgres
end
