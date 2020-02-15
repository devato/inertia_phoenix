defmodule InertiaPhoenix.Controller do
  @moduledoc false
  alias Phoenix.Controller, as: PC

  def render_inertia(%{assigns: %{inertia_request: inertia_request}} = conn, component, assigns)
      when inertia_request == true do
    PC.json(conn, page_map(conn, component, assigns))
  end

  def render_inertia(conn, component, assigns) do
    assigns = [{:component, component} | assigns]

    conn
    |> PC.put_view(InertiaPhoenix.View)
    |> PC.render("inertia.html", assigns)
  end

  defp page_map(conn, component, assigns) do
    assigns_map = Enum.into(assigns, %{})

    %{
      component: component,
      props: assigns_map.props,
      url: conn.request_path,
      version: "1.0"
    }
  end
end
