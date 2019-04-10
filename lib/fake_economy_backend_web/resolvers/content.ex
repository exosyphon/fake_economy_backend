defmodule FakeEconomyBackendWeb.Resolvers.Content do
  def list_posts(_args, %{context: %{current_user: %{id: _id}}}) do
    {:ok, ["tom"]}
  end

  def list_posts(_args, _info) do
    {:error, "Not Authorized"}
  end
end
