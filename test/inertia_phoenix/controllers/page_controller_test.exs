defmodule InertiaPhoenix.PageControllerTest do
  use InertiaPhoenix.ConnCase
  alias Phoenix.HTML.Tag

  setup do
    Logger.disable(self())
    :ok
  end

  test "GET / non-inertia no props", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "false")
      |> put_req_header("x-inertia-version", "1")
      |> get("/")

    page_json =
      Jason.encode!(%{
        component: "Home",
        props: %{},
        url: "/",
        version: "1"
      })

    expected =
      Tag.content_tag(:div, "", [
        {:id, "app"},
        {:data, [page: page_json]}
      ])

    assert html = html_response(conn, 200)
    assert html == Phoenix.HTML.safe_to_string(expected)
  end

  test "GET / non-inertia with props", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "false")
      |> put_req_header("x-inertia-version", "1")
      |> assign(:props, %{hello: "world"})
      |> get("/")

    page_json =
      Jason.encode!(%{
        component: "Home",
        props: %{hello: "world"},
        url: "/",
        version: "1"
      })

    expected =
      Tag.content_tag(:div, "", [
        {:id, "app"},
        {:data, [page: page_json]}
      ])

    assert html = html_response(conn, 200)
    assert html == Phoenix.HTML.safe_to_string(expected)
  end

  test "GET / with x-inertia header", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "1")
      |> assign(:props, %{hello: "world"})
      |> get("/")

    page_map = %{
      "component" => "Home",
      "props" => %{"hello" => "world"},
      "url" => "/",
      "version" => "1"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end

  test "GET / with x-inertia-version mismatch", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "123")
      |> get("/")

    assert conn.assigns.flash == %{}
    assert html_response(conn, 409)
  end

  test "GET / x-inertia-version mismatch forwards flash", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(%{})
      |> fetch_flash()
      |> put_flash(:error, "something went wrong")
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "123")
      |> get("/")

    assert conn.assigns.flash == %{"error" => "something went wrong"}
    assert html_response(conn, 409)

    conn =
      conn
      |> recycle()
      |> Plug.Test.init_test_session(%{})
      |> put_req_header("x-inertia", "false")
      |> get("/")

    assert conn.assigns.flash == %{"error" => "something went wrong"}
    assert html_response(conn, 200)
  end

  test "PUT / with 301", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "1")
      |> put_status(301)
      |> put("/")

    assert json_response(conn, 303)
  end

  test "GET / with x-inertia-partial-data", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "1")
      |> put_req_header("x-inertia-partial-component", "Home")
      |> put_req_header("x-inertia-partial-data", "hello,foo")
      |> assign(:props, %{hello: "world", world: "hello", foo: "bar"})
      |> get("/")

    page_map = %{
      "component" => "Home",
      "props" => %{"hello" => "world", "foo" => "bar"},
      "url" => "/",
      "version" => "1"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end

  test "GET / with x-inertia-partial-data and mismatched x-inertia-partial-component",
       %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "1")
      |> put_req_header("x-inertia-partial-component", "Dashboard")
      |> put_req_header("x-inertia-partial-data", "hello,foo")
      |> assign(:props, %{hello: "world", world: "hello", foo: "bar"})
      |> get("/")

    page_map = %{
      "component" => "Home",
      "props" => %{"hello" => "world", "world" => "hello", "foo" => "bar"},
      "url" => "/",
      "version" => "1"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end

  test "GET / with lazy loaded prop", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "1")
      |> assign(:props, %{hello: fn -> "world" end, foo: "bar"})
      |> get("/")

    page_map = %{
      "component" => "Home",
      "props" => %{"hello" => "world", "foo" => "bar"},
      "url" => "/",
      "version" => "1"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end

  test "GET / with shared props", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "true")
      |> put_req_header("x-inertia-version", "1")
      |> InertiaPhoenix.share(:hello, fn -> :world end)
      |> InertiaPhoenix.share(:foo, :baz)
      |> InertiaPhoenix.share("user", %{name: "José"})
      |> assign(:props, %{foo: "bar"})
      |> get("/")

    page_map = %{
      "component" => "Home",
      "props" => %{"hello" => "world", "foo" => "bar", "user" => %{"name" => "José"}},
      "url" => "/",
      "version" => "1"
    }

    assert json = json_response(conn, 200)
    assert json == page_map
  end

  test "GET / with query params", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-inertia", "false")
      |> put_req_header("x-inertia-version", "1")
      |> get("/?search=dog")

    page_json =
      Jason.encode!(%{
        component: "Home",
        props: %{},
        url: "/?search=dog",
        version: "1"
      })

    expected =
      Tag.content_tag(:div, "", [
        {:id, "app"},
        {:data, [page: page_json]}
      ])

    assert html = html_response(conn, 200)
    assert html == Phoenix.HTML.safe_to_string(expected)
  end
end
