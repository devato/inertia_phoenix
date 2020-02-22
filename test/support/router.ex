defmodule InertiaPhoenix.TestWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_layout, {InertiaPhoenix.TestWeb.LayoutView, :app})
    plug(InertiaPhoenix.Plug)
  end

  scope "/", InertiaPhoenix.TestWeb do
    pipe_through([:browser])

    get("/", PageController, :index, as: :home)
  end
end
