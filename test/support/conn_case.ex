defmodule InertiaPhoenix.ConnCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias InertiaPhoenix.TestWeb.{Endpoint, Router}

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      alias Router.Helpers, as: Routes
      @endpoint Endpoint
    end
  end

  setup do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
