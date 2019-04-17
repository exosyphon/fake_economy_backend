defmodule FakeEconomyBackendWeb.Schema.Types do
  use Absinthe.Schema.Notation

  input_object :update_user_params do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
  end

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :string
  end

  object :financial_account do
    field :id, :id
    field :currency, :string
    field :balance, :integer
    field :type, :string
  end

  object :session do
    field :token, :string
  end
end
