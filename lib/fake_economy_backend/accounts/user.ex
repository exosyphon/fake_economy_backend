defmodule FakeEconomyBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias FakeEconomyBackend.Accounts.User
  alias FakeEconomyBackend.FinancialAccount
  alias FakeEconomyBackend.Job
  alias FakeEconomyBackend.Repo

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :token, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :reset_token, :string
    has_many :financial_accounts, FinancialAccount
    has_many :jobs, Job

    timestamps()
  end

  def create_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> cast_assoc(:financial_accounts)
    |> add_new_pass_hash()
  end

  def update_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:email])
    |> put_pass_hash()
  end

  def update_password_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:password, :reset_token])
    |> validate_required([:password])
    |> add_new_pass_hash()
  end

  def remove_token_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:token])
  end

  def reset_password_changeset(%User{} = user, reset_token) do
    user
    |> cast(%{token: nil, password_hash: "", reset_token: reset_token}, [:token, :password_hash, :reset_token])
  end

  def store_token_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:token])
    |> validate_required([:token])
  end

  defp add_new_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, Bcrypt.add_hash(password))
      _ ->
        changeset
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end

  def authenticate(params) do
    user = Repo.get_by(User, email: String.downcase(params.email))
    case check_password(user, params.password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect login credentials"}
    end
  end

  def logout(params) do
    Repo.get_by(User, email: String.downcase(params.email))
    |> User.remove_token_changeset(%{token: nil})
    |> Repo.update!()
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> case user.password_hash do
        nil -> false
        _ -> Bcrypt.verify_pass(password, user.password_hash)
      end
    end
  end
end
