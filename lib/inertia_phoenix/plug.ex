defmodule InertiaPhoenix.Plug do
  @moduledoc false
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> put_resp_header("Vary", "Accept")
        |> put_resp_header("X-Inertia", "true")
        |> assign(:inertia_request, true)

      _ ->
        assign(conn, :inertia_request, false)
    end
  end
end
