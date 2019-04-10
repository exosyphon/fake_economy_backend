defmodule FakeEconomyBackend.Accounts do
  import Ecto.Query, warn: false
  alias FakeEconomyBackend.Repo
  alias FakeEconomyBackend.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def store_user(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
