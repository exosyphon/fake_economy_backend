defmodule FakeEconomyBackendWeb.Resolvers.FinancialAccount do
  import Ecto.Query, warn: false
  alias FakeEconomyBackend.FinancialAccount
  alias FakeEconomyBackend.Repo

  def all(_args, %{context: %{current_user: %{id: id}}}) do
    {:ok, Repo.all(FinancialAccount, user_id: id) }
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end
end
