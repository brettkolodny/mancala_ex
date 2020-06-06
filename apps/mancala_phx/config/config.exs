# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mancala_phx,
  namespace: MancalaPhx

# Configures the endpoint
config :mancala_phx, MancalaPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nXQ8aVlGnFZw6DJ8UawsxkkHfUK6CD309RFECOjqAqwinA7z6j7h+zNymXSf5ZlX",
  render_errors: [view: MancalaPhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MancalaPhx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
