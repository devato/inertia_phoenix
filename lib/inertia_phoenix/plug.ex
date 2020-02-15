defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> put_resp_header("vary", "accept")
        |> put_resp_header("x-inertia", "true")
        |> assign(:inertia_request, true)
        # https://inertiajs.com/security#csrf-protection
        |> put_resp_cookie("XSRF-TOKEN", Phoenix.Controller.get_csrf_token())

      _ ->
        conn
        |> assign(:inertia_request, false)
        # https://inertiajs.com/security#csrf-protection
        |> put_resp_cookie("XSRF-TOKEN", Phoenix.Controller.get_csrf_token())
    end
  end
end
