defmodule Songmate.Repo do
  use Ecto.Repo,
    otp_app: :songmate,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query
  alias Songmate.Repo

  def get_or_insert_by!(schema, params, attrs) do
    Repo.get_by(schema, params) || Repo.insert!(schema.changeset(struct(schema), attrs))
  end

  def all_with_order(schema, field, ordered_subset) do
    unordered_result = Repo.all(from(row in schema, where: field(row, ^field) in ^ordered_subset))

    Enum.map(ordered_subset, fn id ->
      Enum.find(unordered_result, &(Map.get(&1, field) == id))
    end)
  end
end
