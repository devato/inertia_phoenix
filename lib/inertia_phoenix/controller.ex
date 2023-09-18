defmodule InertiaPhoenix.Controller do
  @moduledoc false
  import InertiaPhoenix
  require Logger

  import Plug.Conn,
    only: [
      get_req_header: 2,
      put_resp_header: 3,
      put_resp_cookie: 4,
      assign: 3
    ]

  alias Phoenix.Controller

  def render_inertia(conn, component, assigns \\ [props: %{}])

  def render_inertia(%{assigns: %{inertia_request: true}} = conn, component, assigns) do
    assigns = build_assigns(conn, assigns, component)

    conn
    |> put_resp_header("vary", "accept")
    |> put_resp_header("x-inertia", "true")
    |> put_csrf_cookie
    |> Controller.json(page_map(conn, assigns))
  end

  def render_inertia(conn, component, assigns) do
    assigns = build_assigns(conn, assigns, component)

    %{"body" => body, "head" => raw_head} = fetch_ssr(conn, assigns)
    assigns = Keyword.put(assigns, :inertia_ssr_body, body)
    head = Phoenix.HTML.raw(Enum.join(raw_head, "\n"))

    conn
    |> Controller.put_view(InertiaPhoenix.View)
    |> Controller.put_layout(html: {InertiaPhoenix.View, :inertia})
    |> put_csrf_cookie
    |> assign(:inertia_ssr_head, head)
    |> Controller.render("inertia.html", assigns)
  end

  defp fetch_ssr(conn, assigns) do
    default = %{
      "head" => [],
      "body" => ""
    }

    if inertia_ssr_enabled() do
      case HTTPoison.post(inertia_ssr_url() <> "/render", Jason.encode!(page_map(conn, assigns)), [{"Content-Type", "application/json"}]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          if body == "" do
            Logger.warn("Inertia SSR returned empty response, check SSR server logs")
            default
          else
            Jason.decode!(body)
          end
        response ->
          Logger.warn("Inertia SSR request failed: #{inspect(response)}")
          default
      end
    else
      default
    end
  end

  defp build_assigns(conn, assigns, component) do
    assigns
    |> filter_partial_data(conn, component)
    |> merge_shared_props(conn)
    |> lazy_load()
    |> assign_component(component)
    |> assign_flash(Map.get(conn.assigns, :flash, %{}))
  end

  defp page_map(conn, assigns) do
    assigns_map = Enum.into(assigns, %{})

    %{
      component: assigns_map.component,
      props: assigns_map.props,
      url: path_with_params(conn),
      version: assets_version()
    }
  end

  defp assign_component(assigns, component) do
    [{:component, component} | assigns]
  end

  defp assign_flash(assigns, flash) when map_size(flash) == 0, do: assigns

  defp assign_flash(assigns, flash) do
    put_in(assigns, [:props, :flash], flash)
  end

  defp filter_partial_data(assigns, conn, component) do
    with [component_request] when component_request == component <-
           get_req_header(conn, "x-inertia-partial-component"),
         [partial_data] <- get_req_header(conn, "x-inertia-partial-data") do
      requested_props = String.split(partial_data, ",")

      Keyword.put(
        assigns,
        :props,
        assigns[:props]
        |> Enum.filter(fn {k, _} -> Atom.to_string(k) in requested_props end)
        |> Enum.into(%{})
      )
    else
      _ -> assigns
    end
  end

  defp merge_shared_props(assigns, conn) do
    shared_props = conn.private[:inertia_phoenix_shared_props] || %{}
    props = Map.merge(shared_props, assigns[:props])
    Keyword.put(assigns, :props, props)
  end

  defp lazy_load(assigns) do
    Keyword.put(
      assigns,
      :props,
      Enum.map(assigns[:props], fn {k, v} ->
        if is_function(v) do
          {k, v.()}
        else
          {k, v}
        end
      end)
      |> Enum.into(%{})
    )
  end

  defp put_csrf_cookie(conn) do
    put_resp_cookie(conn, "XSRF-TOKEN", Controller.get_csrf_token(), http_only: false)
  end
end
