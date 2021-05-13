# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :simpleAPI,
  ecto_repos: [SimpleAPI.Repo]

# Configures the endpoint
config :simpleAPI, SimpleAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "E+A/NwcJXu0pa6My/HMZ2bzZ4OBUpwiDYgAP/5YfR2LDsLNJQKD0btrUSgGYNAQz",
  render_errors: [view: SimpleAPIWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SimpleAPI.PubSub,
  live_view: [signing_salt: "mjKNSSEq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
