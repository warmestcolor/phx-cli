defmodule GiverWeb.Router do
  use GiverWeb, :router
  # use Plug.ErrorHandler # 这个会屏蔽发送给前端的错误内容

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :auth_third do
    plug Ueberauth
  end

  pipeline :authenticated do
    plug :auth_token
  end

  scope "/auth", GiverWeb do
    pipe_through [:api, :auth_third]

    get "/logout", AuthenticationController, :delete, as: :auth
    get "/:platform", AuthenticationController, :request, as: :auth
    get "/:platform/callback", AuthenticationController, :callback, as: :auth
    post "/:platform/callback", AuthenticationController, :callback, as: :auth
  end

  scope "/api", GiverWeb do
    pipe_through [:api, :authenticated]
    resources("/users", UserController, except: [:new, :edit])
  end

  ## 验证 token
  defp auth_token(conn, _opts) do
    if user = get_token(conn) |> get_current_user() do
      # 将当前用户暂存在 assigns 中，可通过 conn.assigns.current_user 获取该信息
      conn
      |> conn.assigns(:current_user, user)
    else
      # token 错误或者 user 不存在都返回 401
      conn
      |> put_status(401)
      |> render(GiverWeb.ErrorView, :"401")
      |> halt()
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

  defp get_current_user(token) do
    # token |> IO.inspect(label: ">> TOKEN")
    case GiverWeb.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        Giver.Accounts.get_user(claims["sub"])
      _ ->
        nil
    end
  end
end
