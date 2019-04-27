defmodule FakeEconomyBackendWeb.Schema.Types do
  use Absinthe.Schema.Notation

  input_object :create_user_params do
    field :email, :string
    field :password, :string
    field :password_confirmation, :string
  end

  input_object :update_user_params do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
  end

  input_object :update_user_password do
    field :password, :string
    field :password_confirmation, :string
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

  object :job do
    field :id, :id
    field :pay_period, :string
    field :title, :string
    field :salary, :integer
    field :type, :string
  end

  object :session do
    field :token, :string
  end
end
