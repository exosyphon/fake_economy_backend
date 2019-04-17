defmodule FakeEconomyBackend.Repo.Migrations.CreateFinancialAccounts do
  use Ecto.Migration

  def change do
    create table(:financial_accounts) do
      add :balance, :integer
      add :currency, :string
      add :type, :string
      add :user_id, references(:users)

      timestamps()
    end

  end
end
