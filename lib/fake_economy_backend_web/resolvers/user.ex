defmodule FakeEconomyBackendWeb.Resolvers.User do
  alias FakeEconomyBackend.Accounts
  alias FakeEconomyBackend.Guardian

  def find(%{id: id}, _info) do
    case Accounts.get_user!(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def update(%{id: id, user: user_params}, _info) do
    Accounts.get_user!(id)
    |> Accounts.update_user(user_params)
  end

  def login(params, _info) do
    with {:ok, user} <- Accounts.User.authenticate(params),
         {:ok, jwt, _ } <- Guardian.encode_and_sign(user),
         {:ok, _ } <- Accounts.store_user(user, jwt)
    do
      {:ok, %{token: jwt}}
    end
  end

  def logout(params, _info) do
    Accounts.User.logout(params)
    {:ok, true}
  end
end
