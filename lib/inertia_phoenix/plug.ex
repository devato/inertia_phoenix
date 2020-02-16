defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn
  alias Phoenix.Controller

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
end
