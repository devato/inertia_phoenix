defmodule InertiaPhoenix.TestWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :inertia_phoenix

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_inertia_phoenix_key",
    signing_salt: "yKZ6VvPl"
  ]

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)

  plug(InertiaPhoenix.TestWeb.Router)
end
