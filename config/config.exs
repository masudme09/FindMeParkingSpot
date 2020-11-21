# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :parkin,
  ecto_repos: [Parkin.Repo]

# Configures the endpoint
config :parkin, ParkinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MxUmz6qQ9X5cgjBy4toz49kswAe1i7mWOi+foQseodivOYDsVy9kxwi0L6fuvZDn",
  render_errors: [view: ParkinWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Parkin.PubSub,
  live_view: [signing_salt: "ikkccbZ9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :parkin, Parkin.Guardian,
  issuer: "parkin",
  secret_key: "Hmj8oL6MD14I7n/Ok2XFWplkhOmegE+sUqU5CRjm5F+ZgGRJ9+z/BrYHhCUdbH/P"
