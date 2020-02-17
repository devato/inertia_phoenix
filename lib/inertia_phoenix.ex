defmodule InertiaPhoenix do
  @moduledoc false

  def assets_version do
    Application.get_env(:inertia_phoenix, :assets_version, "1")
  end
end
