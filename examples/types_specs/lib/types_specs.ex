defmodule TypesSpecs do
  @spec hello() :: atom()
  def hello do
    :world
  end

  @type user :: %{name: String.t, email: String.t}
  @type users :: [user]

  @spec find_by_id(String.t) :: users
  def find_by_id(user_id) do
    [%{name: "joe", email: "joe@somewhere.com"}]
  end
end
