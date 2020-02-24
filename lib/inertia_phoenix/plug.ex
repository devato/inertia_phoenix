defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn
  import InertiaPhoenix

  def init(default), do: default

  def call(conn, _) do
    conn
    |> maybe_merge_flash
    |> check_inertia_req
  end

  defp check_inertia_req(conn) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> check_redirect
        |> check_assets_version
        |> assign(:inertia_request, true)

      _ ->
        assign(conn, :inertia_request, false)
    end
  end

  defp check_assets_version(conn) do
    if conn.method == "GET" && get_req_header(conn, "x-inertia") == ["true"] &&
         get_req_header(conn, "x-inertia-version") != [assets_version()] do
      force_refresh(conn)
    else
      conn
    end
  end

  defp force_refresh(conn) do
    conn
    |> put_resp_header("x-inertia", "true")
    |> put_resp_header("x-inertia-location", request_url(conn))
    |> put_resp_content_type("text/html")
    |> maybe_forward_flash()
    |> send_resp(:conflict, "")
    |> halt()
  end

  defp check_redirect(conn) do
    conn
    |> register_before_send(fn conn ->
      if conn.method in ["PUT", "PATCH", "DELETE"] and conn.status in [301, 302] do
        put_status(conn, 303)
      else
        conn
      end
    end)
  end

  defp maybe_forward_flash(%{private: %{phoenix_flash: flash}} = conn)
       when is_map(flash) and map_size(flash) > 0 do
    put_session(conn, "inertia_flash", flash)
  end

  defp maybe_forward_flash(conn), do: conn

  defp maybe_merge_flash(conn) do
    case get_session(conn, :inertia_flash) do
      nil ->
        conn

      flash ->
        conn
        |> delete_session(:inertia_flash)
        |> put_private(:phoenix_flash, Map.merge(conn.private.phoenix_flash, flash))
    end
  end
end
