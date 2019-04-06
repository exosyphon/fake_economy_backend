defmodule FakeEconomyBackendWeb.Resolvers.Content do

  def list_posts(_parent, _args, _resolution) do
    {:ok, ["tom"]}
  end

end
