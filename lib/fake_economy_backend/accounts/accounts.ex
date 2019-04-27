defmodule FakeEconomyBackend.Accounts do
  import Ecto.Query, warn: false
  alias FakeEconomyBackend.Repo
  alias FakeEconomyBackend.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def existing_user?(%{email: email}), do: Repo.get_by(User, email: String.downcase(email))
  def existing_user?(%{reset_token: reset_token}), do: Repo.get_by(User, reset_token: reset_token)

  def reset_password(%User{} = user, reset_token) do
    user
    |> User.reset_password_changeset(reset_token)
    |> Repo.update()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(Map.merge(attrs, new_user_financial_accounts()))
    |> Repo.insert()
  end

  defp new_user_financial_accounts do
    %{
      financial_accounts: [
        %{type: "checking", currency: "USD", balance: 5000}
      ]
    }
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_user_password(%User{} = user, attrs) do
    user
    |> User.update_password_changeset(Map.merge(attrs, %{reset_token: nil}))
    |> Repo.update()
  end

  def store_user(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end
end
