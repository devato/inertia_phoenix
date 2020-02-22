defmodule InertiaPhoenix.TestWeb.PageController do
  use InertiaPhoenix.TestWeb, :controller

  def index(conn, _params) do
    render_inertia(conn, "Home")
  end
end
