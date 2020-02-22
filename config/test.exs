use Mix.Config

config :phoenix, :json_library, Jason

config :inertia_phoenix, InertiaPhoenix.TestWeb.Endpoint,
  secret_key_base: "1600nhJi38a9JX9k/GiHMziBqXS7OT8jG77brf0JztxLeghY6hVB6ZxV0fDKPNTc",
  debug_errors: false,
  code_reloader: false,
  render_errors: [view: InertiaPhoenix.TestWeb.ErrorView, accepts: ~w(html json)]
