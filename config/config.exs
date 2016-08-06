# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :talkin,
  ecto_repos: [Talkin.Repo]

# Configures the endpoint
config :talkin, Talkin.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9rICIMi2b/DMVCL5B5N8rXuDxFAgnoB8TDKAQ9vecSLql8/6zYuELv9quaCnDMVq",
  render_errors: [view: Talkin.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Talkin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :talkin, Talkin.Repo,
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]
