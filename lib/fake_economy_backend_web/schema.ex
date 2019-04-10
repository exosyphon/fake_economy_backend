defmodule FakeEconomyBackendWeb.Schema do
  use Absinthe.Schema
  import_types(FakeEconomyBackendWeb.Schema.Types)

  alias FakeEconomyBackendWeb.Resolvers

  query do
    @desc "Get all posts"
    field :posts, list_of(:string) do
      resolve(&Resolvers.Content.list_posts/2)
    end
  end

  mutation do
    field :update_user, type: :user do
      arg(:id, non_null(:integer))
      arg(:user, :update_user_params)

      resolve(&Resolvers.User.update/2)
    end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.User.login/2
    end
  end
end
