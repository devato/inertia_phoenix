defmodule InertiaPhoenix.Test.ConnCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias InertiaPhoenix.Test.Endpoint
  alias Plug.Conn

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      @endpoint Endpoint
    end
  end

  @session Plug.Session.init(
             store: :cookie,
             key: "_inertia_phoenix",
             encryption_salt: "yadayada",
             signing_salt: "yadayada"
           )

  setup do
    session_data = %{}

    conn =
      Phoenix.ConnTest.build_conn()
      |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
      |> Plug.Session.call(@session)
      |> Conn.fetch_session()
      |> Conn.put_private(:phoenix_action, :index)
      |> Conn.put_private(:phoenix_router, Router)
      |> Conn.put_private(:phoenix_endpoint, Endpoint)
      |> Conn.put_private(:phoenix_layout, {InertiaPheonix.Test.LayoutView, "app.html"})
      |> InertiaPhoenix.Plug.call([])

    {:ok, conn: conn, session_data: session_data}
  end
end
