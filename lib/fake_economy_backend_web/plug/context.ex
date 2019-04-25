defmodule FakeEconomyBackendWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias FakeEconomyBackend.Repo
  alias FakeEconomyBackend.Accounts.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case FakeEconomyBackend.Guardian.decode_and_verify(token) do
      {:ok, _} -> get_user(token)
      {:error, _} -> {:error, "invalid authorization token"}
    end
  end

  defp get_user(token) do
    User
    |> where(token: ^token)
    |> Repo.one()
    |> case do
      nil -> {:error, "invalid authorization token"}
      user -> {:ok, user}
    end
  end
end
