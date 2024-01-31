# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bAC,
  ecto_repos: [BAC.Repo]

config :bAC, Oban,
  engine: Oban.Pro.Engines.Smart,
  notifier: Oban.Notifiers.PG,
  repo: BAC.Repo,
  plugins: [
    Oban.Pro.Plugins.DynamicPruner
    #Oban.Plugins.Pruner,
    # {Oban.Plugins.Cron,
    #  crontab: [
    #    {"* * * * *", TsOban.StatisticsGenerator},
    #    {"@reboot",TsOban.Workers.DailyEmail},
    #    {"* * * * *",TsOban.Workers.DailyEmail},
    #    {"@hourly", TsOban.StatisticsGenerator},
    #    {"@reboot", TsOban.StatisticsGenerator},
    #    {"@daily", TsOban.StatisticsGenerator}
    #  ]}
  ],
  queues: [default: 10, valid: 12,scheduled: 10, crato: 25, events: [limit: 20, dispatch_cooldown: 10]]


# Configures the endpoint
config :bAC, BACWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: BACWeb.ErrorHTML, json: BACWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BAC.PubSub,
  live_view: [signing_salt: "tpAqIMwr"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :bAC, BAC.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  config :logger,
    backends: [
      :console,
      {LoggerFileBackend, :error_log},
      {LoggerFileBackend, :connection_log}
      ],
    format: "$time [$level] $message $metadata\n",
    metadata: :all

  config :logger, :error_log,
    path: "error.log",
    level: :error

  config :logger, :connection_log,
  path: "oban.log",
  level: :debug

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
