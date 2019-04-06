defmodule FakeEconomyBackend.Repo do
  use Ecto.Repo,
    otp_app: :fake_economy_backend,
    adapter: Ecto.Adapters.Postgres
end
