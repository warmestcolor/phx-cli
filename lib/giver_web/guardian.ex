defmodule GiverWeb.Guardian do
  @moduledoc """
  访问身份jwt校验
  """

  use Guardian, otp_app: :giver

  alias Giver.Accounts

  def subject_for_token(%{id: id} = _resource, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :invalid_token}
  end

  def resource_from_claims(%{"sub" => sub} = claims) do
    case Accounts.get_user(sub) do
      nil ->
        {:error, :invalid_login}
      user ->
        {:ok, user}
    end
  end
end
