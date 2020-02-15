# Phoenertia

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phoenertia` to your list of dependencies in `mix.exs`:

Add to mix.exs:
```
{:inertia_phoenix, "~> 0.1.0"}
```

Add Plug to `WEB_PATH/router.ex`
```
  pipeline :browser do
    ...
    plug InertiaPhoenix.Plug
  end
```

Import render_inertia `lib/active_web.ex`
```
  def controller do
    quote do
      ...
      import InertiaPhoenix.Controller, only: [render_inertia: 3]
    end
  end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/inertia_phoenix](https://hexdocs.pm/inertia_phoenix).

