defmodule InertiaPhoenix.ControllerTest do
  use InertiaPhoenix.Test.ConnCase
  alias Plug.Conn
  alias InertiaPhoenix.Test.Endpoint
  alias Phoenix.HTML.Tag

  test "render_inertia/2 no props", %{conn: conn} do
    conn =
      conn
      |> Conn.put_private(:phoenix_action, :index)
      |> Conn.put_private(:phoenix_endpoint, Endpoint)
      |> InertiaPhoenix.Plug.call([])
      |> InertiaPhoenix.Controller.render_inertia("Home")

    page_json = Jason.encode!(%{
      component: "Home",
      props: %{},
      url: "/",
      version: "1.0"
    })

    expected = Tag.content_tag(:div, "", [
      {:id, "app"},
      {:data, [page: page_json]}
    ])

    assert html = html_response(conn, 200)
    assert html == Phoenix.HTML.safe_to_string(expected)
  end

  test "render_inertia/3 regular",  %{conn: conn} do
    conn =
      conn
      |> Conn.put_private(:phoenix_action, :new)
      |> Conn.put_private(:phoenix_endpoint, Endpoint)
      |> InertiaPhoenix.Controller.render_inertia("Home", props: %{hello: "world"})

    page_json = Jason.encode!(%{
      component: "Home",
      props: %{hello: "world"},
      url: "/",
      version: "1.0"
    })

    expected = Tag.content_tag(:div, "", [
      {:id, "app"},
      {:data, [page: page_json]}
    ])

    assert html = html_response(conn, 200)
    assert html == Phoenix.HTML.safe_to_string(expected)
  end

  test "render_inertia/3 with x-inertia header", %{conn: conn} do
    conn =
      conn
      |> Conn.put_req_header("x-inertia", "true")
      |> Conn.put_private(:phoenix_action, :index)
      |> Conn.put_private(:phoenix_endpoint, Endpoint)
      |> InertiaPhoenix.Plug.call([])
      |> InertiaPhoenix.Controller.render_inertia("Home", props: %{hello: "world"})

    page_map = %{
      "component" => "Home",
      "props" =>  %{"hello" => "world"},
      "url" => "/",
      "version" => "1.0"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end
end
