defmodule FakeEconomyBackendWeb.Resolvers.User do
  alias FakeEconomyBackend.Accounts
  alias FakeEconomyBackend.Guardian

  def find(%{id: id}, _info) do
    case Accounts.get_user!(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def forgot_password(%{email: email}, _info) do
    case Accounts.existing_user?(%{email: email}) do
      user -> send_reset_email(user)
    end

    {:ok, "Reset email sent!"}
  end

  defp send_reset_email(user) do
    reset_token = UUID.uuid4(:hex)
    # send email with token
    Accounts.reset_password(user, reset_token)
  end

  def reset_password(
        %{
          reset_token: reset_token,
          password: password,
          password_confirmation: password_confirmation
        },
        _info
      ) do
    case Accounts.existing_user?(%{reset_token: reset_token}) do
      nil ->
        {:error, "Reset token not found!"}

      user ->
        case valid_password?(password, password_confirmation) do
          {:ok, true} ->
            case Accounts.update_user_password(user, %{password: password}) do
              _ -> {:ok, true}
            end
          {:error, message} ->
            {:error, message}
        end
    end
  end

  def update(%{id: id, user: user_params}, _info) do
    Accounts.get_user!(id)
    |> Accounts.update_user(user_params)
  end

  def update_password(%{password: password, password_confirmation: password_confirmation}, %{
        context: %{current_user: current_user}
      }) do
    case valid_password?(password, password_confirmation) do
      {:ok, _} -> case Accounts.update_user_password(current_user, %{password: password}) do
        _ -> {:ok, true}
      end
      {:error, message} -> {:error, message}
    end
  end

  def update_password(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(
        %{
          user: %{password: password, password_confirmation: password_confirmation} = user_params
        },
        _info
      ) do
    case valid_password?(password, password_confirmation) do
      {:ok, _} ->
        case Accounts.existing_user?(user_params) do
          nil -> Accounts.create_user(user_params)
          _ -> {:error, "User already exists!"}
        end

      {:error, message} ->
        {:error, message}
    end
  end

  defp valid_password?(password, password_confirmation) do
    case password == password_confirmation do
      false ->
        {:error, "Password and Password Confirmation do not match"}

      true ->
        case password =~ ~r/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/ do
          false ->
            {:error,
             "Password must have eight characters, at least one letter, one number and one special character"}

          true ->
            {:ok, true}
        end
    end
  end

  def login(params, _info) do
    with {:ok, user} <- Accounts.User.authenticate(params),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user),
         {:ok, _} <- Accounts.store_user(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def logout(params, _info) do
    Accounts.User.logout(params)
    {:ok, true}
  end
end
