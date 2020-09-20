use Mix.Config

config :mancala, MancalaWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [host: "www.mancala.brettkolodny.com", port: System.get_env("PORT") || 4000], # This is critical for ensuring web-sockets properly authorize.
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:mancala, :vsn)
