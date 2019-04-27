defmodule FakeEconomyBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password_hash, :string
      add :token, :string, size: 2000
      add :reset_token, :string, size: 2000

      timestamps()
    end

  end
end
