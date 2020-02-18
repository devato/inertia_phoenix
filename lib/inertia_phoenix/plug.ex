defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn
  import InertiaPhoenix
  alias Phoenix.Controller

  def init(default), do: default

  def call(conn, _) do
    conn
    |> check_inertia_req
    |> put_csrf_cookie
    |> check_redirect
    |> check_assets_version
  end

  defp check_inertia_req(conn) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> put_resp_header("vary", "accept")
        |> put_resp_header("x-inertia", "true")
        |> assign(:inertia_request, true)

      _ ->
        conn
        |> assign(:inertia_request, false)
    end
  end

  defp put_csrf_cookie(conn) do
    conn |> put_resp_cookie("XSRF-TOKEN", Controller.get_csrf_token(), http_only: false)
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
    |> send_resp(:conflict, "")
    |> halt()
  end

  def check_redirect(conn) do
    conn
    |> register_before_send(fn conn ->
      if conn.method in ["PUT", "PATCH", "DELETE"] and conn.status in [301, 302] do
        put_status(conn, 303)
      else
        conn
      end
    end)
  end
end
