defmodule FakeEconomyBackend.FinancialAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "financial_accounts" do
    field :balance, :integer
    field :currency, :string
    field :type, :string
    belongs_to :user, FakeEconomyBackend.Accounts.User

    timestamps()
  end

  def changeset(financial_account, attrs) do
    financial_account
    |> cast(attrs, [:balance, :currency, :type])
    |> validate_required([:balance, :currency, :type])
  end
end
