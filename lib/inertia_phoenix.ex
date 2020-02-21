defmodule InertiaPhoenix do
  @moduledoc false

  import Logger
  import Plug.Conn

  def share(%Plug.Conn{} = conn, key, val) do
    shared_props =
      case get_session(conn, "inertia_phoenix_shared_props") do
        nil ->
          conn.private
          |> Map.get(:inertia_phoenix_shared_props, %{})
          |> Map.put(key, val)

        data ->
          data
      end

    conn = put_private(conn, :inertia_phoenix_shared_props, shared_props)

    register_before_send(conn, fn conn ->
      shared_props = conn.private.inertia_phoenix_shared_props
      props_size = map_size(shared_props)

      cond do
        is_nil(shared_props) and props_size == 0 ->
          Logger.warn("=> cond 1\n")
          conn

        props_size > 0 and conn.status in 300..308 ->
          Logger.warn("=> cond 2\n")
          put_session(conn, "inertia_phoenix_shared_props", shared_props)

        true ->
          Logger.warn("=> cond 3\n")
          delete_session(conn, "inertia_phoenix_shared_props")
      end
    end)
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
