defmodule Giver.Accounts.Authenticator do
  @moduledoc """
  OAuth授权登录校验处理
  """

  alias Giver.Accounts

  @doc """
  授权登录
  """
  def authenticate(%{uid: uid} = auth_attrs) do
    case Accounts.find_authentication(uid) do
      nil ->
        union_id = auth_attrs.union_id
        prior_auth = Accounts.find_authentication(union_id: union_id)
        {:ok, new_auth} = Accounts.create_authentication(auth_attrs)

        {:ok, user} = Accounts.user_from_auth(new_auth, prior_auth)
        {:ok, new_auth} = Accounts.update_authentication(new_auth,
                                                         %{user_id: user.id})
        {:ok, new_auth, user}

      auth ->
        {:ok, auth, Accounts.get_user!(auth.user_id)}
    end
  end
end
