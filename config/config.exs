# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :mancala_ex_web,
  generators: [context_app: :mancala_ex]

# Configures the endpoint
config :mancala_ex_web, MancalaExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1ChkQabetxLIi32r0O+k61T6Bn3H3Sg14d7AcHilH/VFr4frQO2PU4jsqK9RRo2i",
  render_errors: [view: MancalaExWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MancalaEx.PubSub,
  live_view: [signing_salt: "dSG34jQf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
