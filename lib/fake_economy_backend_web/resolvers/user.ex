defmodule FakeEconomyBackendWeb.Resolvers.User do
  alias FakeEconomyBackend.Accounts

  def find(%{id: id}, _info) do
    case Accounts.get_user!(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def update(%{id: id, user: user_params}, _info) do
    FakeEconomyBackend.Accounts.get_user!(id)
    |> FakeEconomyBackend.Accounts.update_user(user_params)
  end

  def login(params, _info) do
    with {:ok, user} <- FakeEconomyBackend.Accounts.User.authenticate(params),
         {:ok, jwt, _ } <- FakeEconomyBackend.Guardian.encode_and_sign(user),
         {:ok, _ } <- FakeEconomyBackend.Accounts.store_user(user, jwt)
    do
      {:ok, %{token: jwt}}
    end
  end

  def logout(params, _info) do
    FakeEconomyBackend.Accounts.User.logout(params)
    {:ok, true}
  end
end
