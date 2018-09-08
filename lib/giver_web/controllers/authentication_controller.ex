defmodule GiverWeb.AuthenticationController do
  use GiverWeb, :controller
  alias Giver.Accounts.Authenticator

  alias GiverWeb.Guardian
  alias Giver.Logger

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    {:ok, _, user} = Authenticator.authenticate(auth_params(auth))
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user, user)
    |> assign(:current_user, user)
    |> handle_response(auth, user)
  end

  def callback(%{assigns: %{} = auth} = conn, params) do
    fails = auth |> Map.get(:ueberauth_failure)
    Logger.error "ueberauth_failure: #{inspect(fails)}"
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> handle_failure(auth, params)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def handle_failure(conn, auth, %{"provider" => "wechat_miniapp"}) do
    conn
    |> json(auth[:errors])
  end

  def handle_failure(conn, _, _) do
    conn
    |> redirect("/")
  end

  def handle_response(conn, %{provider: :wechat_miniapp}, user) do
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user)

    conn
    |> json(%{token: token})
  end

  def handle_response(conn, _, _) do
    conn
    |> redirect(to: "/")
  end

  def auth_params(%{provider: :wechat_miniapp} = auth) do
    %{
      uid: auth.uid,
      name: auth.info.name || auth.info.nickname,
      nickname: auth.info.nickname,
      avatar: auth.info.image,
      platform: to_string(auth.provider),
      strategy: to_string(auth.strategy),
      union_id: Map.get(auth.extra.raw_info.user, "unionid"),
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      token_secret: auth.credentials.secret,
      gender: Map.get(auth.extra.raw_info.user, "gender") |> gender_cast()
    }
  end

  defp gender_cast(nil), do: nil
  defp gender_cast(num) do
    # num |> IO.inspect(label: ">> Gender")
    case num do
      1 -> 1 # male
      2 -> 0 # female
      0 -> 2 # unknow
      _ -> -1  # unset
    end
  end
end

# 参数示例：
# auth_params(params) <<
#
# params =
# %Ueberauth.Auth{
#   credentials: %Ueberauth.Auth.Credentials{
#     expires: false,
#     expires_at: 0,
#     other: %{},
#     refresh_token: "",
#     scopes: [""],
#     secret: nil,
#     token: "{\"session_key\":\"BmPu293aMogll3f62qRKJA==\",\"expires_in\":7200,\"openid\":\"oMe0A0W1ykLE53uhKLv8gCMNg2OA\"}",
#     token_type: "wechat_miniapp"
#   },
#   extra: %Ueberauth.Auth.Extra{
#     raw_info: %{
#       token: %OAuth2.AccessToken{
#         access_token: "{\"session_key\":\"BmPu293aMogll3f62qRKJA==\",\"expires_in\":7200,\"openid\":\"oMe0A0W1ykLE53uhKLv8gCMNg2OA\"}",
#         expires_at: nil,
#         other_params: %{},
#         refresh_token: nil,
#         token_type: "Bearer"
#       },
#       user: %{
#         "avatarUrl" => "https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKRorziah4Xvf5tNMqhWuicqrMB9yIqf2bkSmiaLibs4RIibRO7IyMvn4Z5WPTHfuUlItWMGCPjiaM2Bpqw/132",
#         "city" => "Shenzhen",
#         "country" => "China",
#         "gender" => 1,
#         "language" => "en",
#         "nickName" => "小亦",
#         "openId" => "oMe0A0W1ykLE53uhKLv8gCMNg2OA",
#         "province" => "Guangdong",
#         "unionid" => nil,
#         "watermark" => %{
#           "appid" => "wxbf1c64086226843c",
#           "timestamp" => 1536434758
#         }
#       }
#     }
#   },
#   info: %Ueberauth.Auth.Info{
#     description: nil,
#     email: nil,
#     first_name: nil,
#     image: "https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKRorziah4Xvf5tNMqhWuicqrMB9yIqf2bkSmiaLibs4RIibRO7IyMvn4Z5WPTHfuUlItWMGCPjiaM2Bpqw/132",
#     last_name: nil,
#     location: nil,
#     name: nil,
#     nickname: "小亦",
#     phone: nil,
#     urls: %{}
#   },
#   provider: :wechat_miniapp,
#   strategy: Ueberauth.Strategy.WechatMiniapp,
#   uid: "oMe0A0W1ykLE53uhKLv8gCMNg2OA"
# }
