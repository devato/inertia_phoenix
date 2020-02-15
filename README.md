# Phoenertia

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phoenertia` to your list of dependencies in `mix.exs`:

```
def deps do
  [
    {:inertia_phoenix, "~> 0.1.0"}
  ]
end
```

router.ex
```
  pipeline :browser do
    ...
    plug InertiaPhoenix.Plug
  end
```

lib/active_web.ex
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
be found at [https://hexdocs.pm/phoenertia](https://hexdocs.pm/phoenertia).

