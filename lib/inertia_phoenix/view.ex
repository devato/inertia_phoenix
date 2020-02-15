defmodule InertiaPhoenix.View do
  def render("inertia.html", assigns) do
    Phoenix.HTML.Tag.content_tag(:div, "", [
      {:id, "app"},
      {:data, [page: page_data(assigns)]}
    ])
  end

  defp page_data(%{conn: conn}) do
    Jason.encode!(%{
      component: "Home",
      props: conn.assigns.props,
      url: "/",
      version: "1.0"
    })
  end
end
