defmodule InertiaPhoenix.Plug do
  import Plug.Conn

  def init(default), do: default

  # def call(%{req_headers: %{"x-inertia" => is_inertia}} = conn, _) do
  #   IO.inspect("============ header is inertia")
  #   IO.inspect(conn.req_headers)
  #   assign(conn, :inertia_request, true)
  # end

  def call(conn, _) do
    case get_req_header(conn, "x-inertia") do
      ["true"] ->
        conn
        |> put_resp_header("Vary", "Accept")
        |> put_resp_header("X-Inertia", "true")
        |> assign(:inertia_request, true)
      _ -> assign(conn, :inertia_request, false)
    end
  end
end

