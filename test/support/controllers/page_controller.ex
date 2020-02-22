defmodule InertiaPhoenix.TestWeb.PageController do
  use InertiaPhoenix.TestWeb, :controller

  def index(%{assigns: %{props: props}} = conn, _params) do
    render_inertia(conn, "Home", props: props || %{})
  end

  def index(conn, _params) do
    render_inertia(conn, "Home")
  end
end
