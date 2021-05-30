defmodule Songmate.CustomAssertions do
  import ExUnit.Assertions

  def assert_same_list_by(field, list1, list2) do
    # Do not inline this to have better error messages
    left = Enum.map(list1, &Map.get(&1, field))
    right = Enum.map(list2, &Map.get(&1, field))
    assert left == right
  end
end
