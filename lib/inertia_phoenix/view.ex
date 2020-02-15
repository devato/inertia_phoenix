defmodule InertiaPhoenix.View do
  @moduledoc false
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
      url: conn.request_path,
      version: "1.0"
    })
  end
end
