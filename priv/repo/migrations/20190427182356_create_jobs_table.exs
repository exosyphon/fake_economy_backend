defmodule FakeEconomyBackend.Repo.Migrations.CreateJobsTable do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :salary, :integer
      add :title, :string
      add :type, :string
      add :pay_period, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
