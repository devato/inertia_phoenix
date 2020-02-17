defmodule InertiaPhoenix.Controller do
  @moduledoc false
  alias Phoenix.Controller

  def render_inertia(conn, component, assigns \\ [props: %{}])

  def render_inertia(%{assigns: %{inertia_request: true}} = conn, component, assigns) do
    assigns =
      assigns
      |> assign_component(component)
      |> assign_flash(Controller.get_flash(conn))

    Controller.json(conn, page_map(conn, assigns))
  end

  def render_inertia(conn, component, assigns) do
    assigns =
      assigns
      |> assign_component(component)
      |> assign_flash(Controller.get_flash(conn))

    conn
    |> Controller.put_view(InertiaPhoenix.View)
    |> Controller.render("inertia.html", assigns)
  end

  defp page_map(conn, assigns) do
    assigns_map = Enum.into(assigns, %{})

    %{
      component: assigns_map.component,
      props: assigns_map.props,
      url: conn.request_path,
      version: "1.0"
    }
  end

  defp assign_component(assigns, component) do
    [{:component, component} | assigns]
  end

  defp assign_flash(assigns, flash) when map_size(flash) == 0, do: assigns

  defp assign_flash(assigns, flash) do
    put_in(assigns, [:props, :flash], flash)
  end
end
