defmodule InertiaPhoenix do
  @moduledoc false
  import Plug.Conn

  def share(%Plug.Conn{} = conn, key, val) do
    shared_props =
      conn.private
      |> Map.get(:inertia_phoenix_shared_props, %{})
      |> Map.put(key, val)

    put_private(conn, :inertia_phoenix_shared_props, shared_props)
  end

  def assets_version do
    Application.get_env(:inertia_phoenix, :assets_version, "1")
    |> to_string
  end

  def inertia_layout do
    Application.get_env(:inertia_phoenix, :inertia_layout, "app.html")
    |> to_string
  end
end
