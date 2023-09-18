defmodule InertiaPhoenix.ViewHelper do
  def inertia_head(conn) do
    conn.assigns[:inertia_ssr_head]
  end
end
