import Config

config :nodeping_push,
  config_file: "/path/to/nodeping_push/priv/config/configs.json"

config :nodeping_push, NodepingPUSH.Scheduler,
  jobs: [
    {"* * * * *", {NodepingPUSH, :run_jobs, [1]}},
    {"*/3 * * * *", {NodepingPUSH, :run_jobs, [3]}},
    {"*/5 * * * *", {NodepingPUSH, :run_jobs, [5]}},
    {"*/15 * * * *", {NodepingPUSH, :run_jobs, [15]}},
    {"*/30 * * * *", {NodepingPUSH, :run_jobs, [30]}},
    {"*/60 * * * *", {NodepingPUSH, :run_jobs, [60]}}
  ]

config :logger,
  backends: [{LoggerFileBackend, :warn_log}, {LoggerFileBackend, :info_log}]

config :logger, :info_log,
  format: "\n$date $time [$level] $levelpad$message",
  path: "/path/to/nodeping_push/info.log",
  level: :info

import_config("#{Mix.env()}.exs")
