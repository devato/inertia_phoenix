defmodule InertiaPhoenix.View do
  def render("inertia.html", assigns) do
    Phoenix.HTML.Tag.content_tag(:div, "", [{:id, "app"}, {:data, [page: page_data()]}])
  end

  defp page_data do
    Jason.encode!(%{
      component: "Home",
      props: %{hello: "world"},
      url: "/",
      version: "1.0"
    })
  end
end
