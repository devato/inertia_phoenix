defmodule InertiaPhoenix.Controller do
  @moduledoc false
  import InertiaPhoenix
  import Plug.Conn, only: [get_req_header: 2]
  alias Phoenix.Controller

  def render_inertia(conn, component, assigns \\ [props: %{}])

  def render_inertia(%{assigns: %{inertia_request: true}} = conn, component, assigns) do
    assigns =
      assigns
      |> filter_partial_data(conn)
      |> merge_shared_props(conn)
      |> lazy_load()
      |> assign_component(component)
      |> assign_flash(Controller.get_flash(conn))

    Controller.json(conn, page_map(conn, assigns))
  end

  def render_inertia(conn, component, assigns) do
    assigns =
      assigns
      |> filter_partial_data(conn)
      |> merge_shared_props(conn)
      |> lazy_load()
      |> assign_component(component)
      |> assign_flash(Controller.get_flash(conn))

    conn
    |> Controller.put_view(InertiaPhoenix.View)
    |> Controller.put_layout(inertia_layout())
    |> Controller.render("inertia.html", assigns)
  end

  defp page_map(conn, assigns) do
    assigns_map = Enum.into(assigns, %{})

    %{
      component: assigns_map.component,
      props: assigns_map.props,
      url: conn.request_path,
      version: assets_version()
    }
  end

  defp assign_component(assigns, component) do
    [{:component, component} | assigns]
  end

  defp assign_flash(assigns, flash) when map_size(flash) == 0, do: assigns

  defp assign_flash(assigns, flash) do
    put_in(assigns, [:props, :flash], flash)
  end

  defp filter_partial_data(assigns, conn) do
    case get_req_header(conn, "x-inertia-partial-data") do
      [] ->
        assigns

      [partial_data] ->
        requested_props = String.split(partial_data, ",")

        Keyword.put(
          assigns,
          :props,
          assigns[:props]
          |> Enum.filter(fn {k, _} -> Atom.to_string(k) in requested_props end)
          |> Enum.into(%{})
        )
    end
  end

  defp merge_shared_props(assigns, conn) do
    shared_props = conn.private[:inertia_phoenix_shared_props] || %{}
    props = Map.merge(shared_props, assigns[:props])

    Keyword.put(assigns, :props, props)
  end

  defp lazy_load(assigns) do
    Keyword.put(
      assigns,
      :props,
      Enum.map(assigns[:props], fn {k, v} ->
        if is_function(v) do
          {k, v.()}
        else
          {k, v}
        end
      end)
      |> Enum.into(%{})
    )
  end
end
