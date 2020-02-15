defmodule InertiaPhoenix.View do
  def render("inertia.html", assigns) do
    Phoenix.HTML.Tag.content_tag(:div, "", [
      {:id, "app"},
      {:data, [page: page_data(assigns)]}
    ])
  end

  def render("inertia.json", assigns) do
    page_data(assigns)
  end

  defp page_data(%{conn: conn}) do
    Jason.encode!(%{
      component: conn.assigns.component,
      props: conn.assigns.props,
      url: conn.request_path,
      version: "1.0"
    })
  end
end
