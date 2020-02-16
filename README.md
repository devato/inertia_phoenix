# Inertia Phoenix

![Tests](https://github.com/devato/inertia_phoenix/workflows/Tests/badge.svg)

Inertiajs Adapter for Elixir Phoenix

## Installation

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

## Render from Controller

```
def index(conn, _params) do
  render_inertia(conn, "Home", props: %{hello: "world"})
end
```

## Pingcrm Example (wip)

https://github.com/devato/pingcrm

