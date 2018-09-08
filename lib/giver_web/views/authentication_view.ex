defmodule GiverWeb.AuthenticationView do
  use GiverWeb, :view
  alias GiverWeb.AuthenticationView

  def render("index.json", %{authentications: authentications}) do
    %{data: render_many(authentications, AuthenticationView, "authentication.json")}
  end

  def render("show.json", %{authentication: authentication}) do
    %{data: render_one(authentication, AuthenticationView, "authentication.json")}
  end

  def render("authentication.json", %{authentication: authentication}) do
    %{id: authentication.id,
      email: authentication.email,
      telphone: authentication.telphone,
      avatar: authentication.avatar,
      nickname: authentication.nickname,
      platform: authentication.platform,
      token: authentication.token,
      refresh_token: authentication.refresh_token,
      token_secret: authentication.token_secret,
      uid: authentication.uid,
      union_id: authentication.union_id}
  end
end
