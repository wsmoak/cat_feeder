# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :cat_feeder, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:cat_feeder, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

#config :nerves_interim_wifi,
#  regulatory_domain: "US"

ssid = System.get_env("SSID") || raise "Set the SSID env var!"
psk = System.get_env("PSK") || raise "Set the PSK env var!"

config :cat_feeder, :wlan0,
  ssid: ssid,
  key_mgmt: :"WPA-PSK",
  psk: psk

config :cat_feeder_web, CatFeederWeb.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "abc-123-def-456",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
