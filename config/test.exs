use Mix.Config

config :tgdb,
  api_key: {:system, "TGDB_TEST_API_KEY"},
  api_root: {:system, "TGDB_TEST_API_ROOT"}

config :logger, level: :info
