defmodule InertiaPhoenix.TestWeb.ErrorHTML do
  @moduledoc false
  def render("500.html", _assigns), do: "Internal Server Error"
  def render("400.html", _assigns), do: "Bad Request"
  def render("404.html", _assigns), do: "Not Found"
end
