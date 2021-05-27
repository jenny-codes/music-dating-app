defmodule Songmate.Repo do
  use Ecto.Repo,
    otp_app: :songmate,
    adapter: Ecto.Adapters.Postgres

  alias Songmate.Repo

  def get_or_create_by!(schema, [], attrs) do
    Repo.insert!(schema.changeset(struct(schema), attrs))
  end

  def get_or_create_by!(schema, [attr_name | candidates], attrs) do
    value = attrs[attr_name]

    (!is_nil(value) && Repo.get_by(schema, [{attr_name, value}])) ||
      get_or_create_by!(schema, candidates, attrs)
  end

  def get_or_create_by!(schema, attr_name, attrs) do
    value = attrs[attr_name]

    (!is_nil(value) && Repo.get_by(schema, [{attr_name, value}])) ||
      Repo.insert!(schema.changeset(struct(schema), attrs))
  end
end
