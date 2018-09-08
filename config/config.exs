# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :giver,
  ecto_repos: [Giver.Repo]

# Configures the endpoint
config :giver, GiverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yourkeybase,need-large-than-64-bit-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  render_errors: [view: GiverWeb.ErrorView, accepts: ~w(json)],
  # debug_errors: false, # 开启后会显示错误信息，适合 debug 模式
  pubsub: [name: Giver.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# JWT
config :giver, GiverWeb.Guardian,
  issuer: "giver",
  secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

# 微信小程序等第三方验权
config :ueberauth, Ueberauth,
  providers: [
    wechat_miniapp: {Ueberauth.Strategy.WechatMiniapp, []}
  ]

# 微信小程序等第三方验权 配置
config :ueberauth, Ueberauth.Strategy.WechatMiniapp.OAuth,
  client_id: System.get_env("WECHAT_MINIAPP_APPID") || "",
  client_secret: System.get_env("WECHAT_MINIAPP_SECRET") || ""

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
