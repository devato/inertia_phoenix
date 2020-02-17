defmodule InertiaPhoenix.ControllerTest do
  use InertiaPhoenix.Test.ConnCase
  alias Plug.Conn
  alias Phoenix.HTML.Tag

  test "render_inertia/2 no props", %{conn: conn} do
    conn =
      conn
      |> Conn.put_req_header("x-inertia", "false")
      |> Conn.put_req_header("x-inertia-version", "1")
      |> fetch_session
      |> fetch_flash
      |> InertiaPhoenix.Controller.render_inertia("Home")

    page_json =
      Jason.encode!(%{
        component: "Home",
        props: %{},
        url: "/",
        version: "1.0"
      })

    expected =
      Tag.content_tag(:div, "", [
        {:id, "app"},
        {:data, [page: page_json]}
      ])

    assert html = html_response(conn, 200)
    assert html == Phoenix.HTML.safe_to_string(expected)
  end

  test "render_inertia/3 regular", %{conn: conn} do
    conn =
      conn
      |> Conn.put_req_header("x-inertia", "false")
      |> Conn.put_req_header("x-inertia-version", "1")
      |> fetch_session
      |> fetch_flash
      |> InertiaPhoenix.Controller.render_inertia("Home", props: %{hello: "world"})

    page_json =
      Jason.encode!(%{
        component: "Home",
        props: %{hello: "world"},
        url: "/",
        version: "1.0"
      })

    expected =
      Tag.content_tag(:div, "", [
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
      |> Conn.put_req_header("x-inertia-version", "1")
      |> fetch_session
      |> fetch_flash
      |> InertiaPhoenix.Plug.call([])
      |> InertiaPhoenix.Controller.render_inertia("Home", props: %{hello: "world"})

    page_map = %{
      "component" => "Home",
      "props" => %{"hello" => "world"},
      "url" => "/",
      "version" => "1.0"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end

  test "render_inertia/3 with x-inertia-version mismatch", %{conn: conn} do
    conn =
      conn
      |> Conn.put_req_header("x-inertia", "true")
      |> Conn.put_req_header("x-inertia-version", "123")
      |> fetch_session
      |> fetch_flash
      |> InertiaPhoenix.Plug.call([])
      |> InertiaPhoenix.Controller.render_inertia("Home", props: %{hello: "world"})

    assert html = html_response(conn, 409)
  end

  test "render_inertia/3 PUT request with 301", %{conn: conn} do
    conn =
      conn
      |> Conn.put_req_header("x-inertia", "false")
      |> Conn.put_req_header("x-inertia-version", "1")
      |> fetch_session
      |> fetch_flash
      |> put_status(301)
      |> Map.put(:method, "PUT")
      |> InertiaPhoenix.Plug.call([])
      |> InertiaPhoenix.Controller.render_inertia("Home")

    assert html = html_response(conn, 303)
  end
end
