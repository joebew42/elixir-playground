defmodule TypesSpecs do
  @spec hello() :: atom()
  def hello do
    :world
  end

  @type user :: %{name: String.t, email: String.t}
  @type users :: [user]

  @spec find_by_id(number) :: users | []
  def find_by_id(user_id) when user_id > 0 do
    [%{name: "joe", email: "joe@somewhere.com"}]
  end

  def find_by_id(_user_id) do
    []
  end
end
