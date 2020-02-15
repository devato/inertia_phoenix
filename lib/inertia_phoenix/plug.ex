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

      _ ->
        assign(conn, :inertia_request, false)
    end
  end
end
