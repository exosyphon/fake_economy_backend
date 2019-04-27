defmodule FakeEconomyBackend.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :title, :string
    field :salary, :integer
    field :type, :string
    field :pay_period, :string
    belongs_to :user, FakeEconomyBackend.Accounts.User

    timestamps()
  end

  def changeset(job, attrs) do
    job
    |> cast(attrs, [:title, :salary, :type, :pay_period])
    |> validate_required([:title, :salary, :type, :pay_period])
  end
end
