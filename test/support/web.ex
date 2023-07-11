defmodule InertiaPhoenix.TestWeb do
  def controller do
    quote do
      use Phoenix.Controller,
        namespace: InertiaPhoenix.TestWeb,
        formats: [:html, :json],
        layouts: [html: InertiaPhoenix.TestWeb.Layouts]

      import InertiaPhoenix.Controller

      import Plug.Conn
      alias InertiaPhoenix.TestWeb.Router.Helpers, as: Routes
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      alias InertiaPhoenix.TestWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
