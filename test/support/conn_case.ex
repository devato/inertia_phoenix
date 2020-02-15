defmodule InertiaPhoenix.Test.ConnCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias InertiaPhoenix.Test.Endpoint

  using do
    quote do
      use Phoenix.ConnTest
      @endpoint Endpoint
    end
  end

  setup do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
