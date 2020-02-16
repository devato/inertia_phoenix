defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    conn
    |> check_inertia_req
  end

  defp check_inertia_req(conn) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> put_resp_header("vary", "accept")
        |> put_resp_header("x-inertia", "true")
        |> assign(:inertia_request, true)
        |> set_csrf_cookie
      _ ->
        conn
        |> assign(:inertia_request, false)
        |> set_csrf_cookie
    end
  end

  defp set_csrf_cookie(conn) do
    conn |> put_resp_cookie("XSRF-TOKEN", Phoenix.Controller.get_csrf_token())
  end

end
