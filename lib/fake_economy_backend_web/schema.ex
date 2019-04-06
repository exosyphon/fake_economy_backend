defmodule FakeEconomyBackendWeb.Schema do
  use Absinthe.Schema
  import_types FakeEconomyBackendWeb.Schema.ContentTypes

  alias FakeEconomyBackendWeb.Resolvers

  query do
    @desc "Get all posts"
    field :posts, list_of(:string) do
      resolve &Resolvers.Content.list_posts/3
    end
  end
end
