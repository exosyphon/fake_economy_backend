defmodule FakeEconomyBackendWeb.Schema do
  use Absinthe.Schema
  import_types(FakeEconomyBackendWeb.Schema.Types)

  alias FakeEconomyBackendWeb.Resolvers

  query do
    @desc "Get all jobs"
    field :jobs, list_of(:job) do
      resolve(&Resolvers.Job.all/2)
    end

    @desc "Get all financial accounts"
    field :financial_accounts, type: list_of(:financial_account) do
      resolve(&Resolvers.FinancialAccount.all/2)
    end
  end

  mutation do
    @desc "Create user account"
    field :create_user, type: :user do
      arg(:user, :create_user_params)

      resolve(&Resolvers.User.create/2)
    end

    @desc "Forgot password"
    field :forgot_password, type: :string do
      arg :email, non_null(:string)

      resolve(&Resolvers.User.forgot_password/2)
    end

    @desc "Reset password"
    field :reset_password, type: :boolean do
      arg :reset_token, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)

      resolve(&Resolvers.User.reset_password/2)
    end

    @desc "Update password"
    field :update_password, type: :boolean do
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)

      resolve(&Resolvers.User.update_password/2)
    end

    @desc "Update user values"
    field :update_user, type: :user do
      arg(:id, non_null(:integer))
      arg(:user, :update_user_params)

      resolve(&Resolvers.User.update/2)
    end

    @desc "Login"
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.User.login/2
    end

    @desc "Logout"
    field :logout, type: :boolean do
      arg :email, non_null(:string)

      resolve &Resolvers.User.logout/2
    end
  end
end
