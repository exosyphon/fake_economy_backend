defmodule FakeEconomyBackendWeb.Resolvers.Job do
  import Ecto.Query, warn: false
  alias FakeEconomyBackend.Job
  alias FakeEconomyBackend.Repo

  def all(_args, %{context: %{current_user: %{id: id}}}) do
    {:ok, Repo.all(from(j in Job, where: j.user_id == ^id))}
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end
end
