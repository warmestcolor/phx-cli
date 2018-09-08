use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :giver, GiverWeb.Endpoint,
  http: [port: System.get_env("GIVER_WEB_PORT") || 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :giver, Giver.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("GIVER_DB_HOST") || "localhost",
  username: System.get_env("GIVER_DB_USER") || "neo",
  password: System.get_env("GIVER_DB_PASSWORD") || "",
  database: System.get_env("GIVER_DB_NAME") || "giver_test",
  port: System.get_env("GIVER_DB_PORT") || 5432,
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, :log_rounds, 4
