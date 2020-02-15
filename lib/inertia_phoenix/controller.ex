defmodule InertiaPhoenix.Controller do

  def render_inertia(%{assigns: %{inertia_request: inertia_request}} = conn, component, assigns) when inertia_request == true do
    IO.puts("x-intertia is true")
    conn
    |> Phoenix.Controller.put_layout(false)
    |> Phoenix.Controller.put_view(InertiaPhoenix.View)
    |> Phoenix.Controller.render("inertia.json", assigns)
  end

  def render_inertia(conn, component, assigns) do
    IO.puts("regular render")
    conn
    |> Phoenix.Controller.put_view(InertiaPhoenix.View)
    |> Phoenix.Controller.render("inertia.html", assigns)
  end

end
