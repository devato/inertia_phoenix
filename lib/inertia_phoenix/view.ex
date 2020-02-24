defmodule InertiaPhoenix.View do
  @moduledoc false
  import InertiaPhoenix
  alias Phoenix.HTML.Tag

  def render("inertia.html", assigns) do
    Tag.content_tag(:div, "", [
      {:id, "app"},
      {:data, [page: page_json(assigns)]}
    ])
  end

  defp page_json(%{conn: conn}) do
    Jason.encode!(%{
      component: conn.assigns.component,
      props: conn.assigns.props,
      url: path_with_params(conn),
      version: assets_version()
    })
  end
end
