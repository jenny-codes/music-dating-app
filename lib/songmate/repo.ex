defmodule Songmate.Repo do
  use Ecto.Repo,
    otp_app: :songmate,
    adapter: Ecto.Adapters.Postgres

  alias Songmate.Repo

  def get_or_insert_by!(schema, params, attrs) do
    Repo.get_by(schema, params) || Repo.insert!(schema.changeset(struct(schema), attrs))
  end
end
