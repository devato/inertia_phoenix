defmodule IntertiaPhoenix do
  @moduledoc """
  Documentation for `IntertiaPhoenix`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> IntertiaPhoenix.hello()
      :world

  """
  def hello do
    :world
  end

  def render_inertia(conn, component, props) do
    Phoenix.Controller.render(conn, "index.html", message: "Hello")
  end
end
