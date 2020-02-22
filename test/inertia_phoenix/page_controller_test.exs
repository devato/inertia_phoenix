defmodule InertiaPhoenix.TestWeb.PageControllerTest do
  use InertiaPhoenix.ConnCase
  alias Plug.Conn
  alias Phoenix.HTML.Tag

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
