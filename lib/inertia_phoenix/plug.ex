defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn
  import InertiaPhoenix
  alias Phoenix.Controller

  def init(default), do: default

  def call(conn, _) do
    conn
    |> check_inertia_req
    |> check_assets_version
    |> check_redirect
  end

  defp check_inertia_req(conn) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> put_resp_header("vary", "accept")
        |> put_resp_header("x-inertia", "true")
        |> assign(:inertia_request, true)
        |> put_csrf_cookie

      _ ->
        conn
        |> assign(:inertia_request, false)
        |> put_csrf_cookie
    end
  end

  defp put_csrf_cookie(conn) do
    conn |> put_resp_cookie("XSRF-TOKEN", Controller.get_csrf_token())
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
    |> put_status(:conflict)
    |> halt()
  end

  def check_redirect(conn) do
    conn
    |> Plug.Conn.register_before_send(fn conn ->
      case(conn.method in ["PUT", "PATCH", "DELETE"] and conn.status in [301, 302]) do
        true ->
          conn |> put_status(303)

        _ ->
          conn
      end
    end)
  end
end
