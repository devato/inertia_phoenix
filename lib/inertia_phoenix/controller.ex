defmodule InertiaPhoenix.Controller do
  def render_inertia(conn, component, assigns) do
    conn
    |> Phoenix.Controller.put_view(InertiaPhoenix.View)
    |> Phoenix.Controller.render("inertia.html", assigns)
  end
end
