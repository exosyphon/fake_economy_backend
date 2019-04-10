defmodule FakeEconomyBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias FakeEconomyBackend.Accounts.User
  alias FakeEconomyBackend.Repo

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :token, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @spec changeset(
          FakeEconomyBackend.Accounts.User.t(),
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
  end

  def update_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> put_pass_hash()
  end

  def registration_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> put_pass_hash()
  end

  def store_token_changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:token])
    |> validate_required([:token])
    |> put_pass_hash()
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

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Bcrypt.verify_pass(password, user.password_hash)
    end
  end
end
