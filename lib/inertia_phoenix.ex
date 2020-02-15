defmodule InertiaPhoenix do
  @moduledoc """
  Documentation for `InertiaPhoenix`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> InertiaPhoenix.hello()
      :world

  """
  def hello do
    :world
  end

  def render_inertia(conn, component, props) do
    Phoenix.Controller.render(conn, "index.html", message: "Hello")
  end
end
