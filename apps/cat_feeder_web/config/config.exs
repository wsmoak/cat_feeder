# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :cat_feeder_web, CatFeederWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "asUzNZv76N0c80k/JUtaTWkSSdxyP9venRTQu2nxb8iVakJnEjUQmjJhcmKgtlAK",
  render_errors: [view: CatFeederWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CatFeederWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
# I think this changed the logs on the firmware,
#config :logger, :console,
#  format: "$time $metadata[$level] $message\n",
#  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
