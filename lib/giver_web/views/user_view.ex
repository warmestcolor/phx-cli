defmodule GiverWeb.UserView do
  use GiverWeb, :view
  alias GiverWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      nickname: user.nickname,
      # is_active: user.is_active,
      telephone: user.telephone,
      email: user.email,
      gender: user.gender,
      birthday: user.birthday,
      avatar: user.avatar}
  end
end
