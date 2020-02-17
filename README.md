# Inertia Phoenix

![Tests](https://github.com/devato/inertia_phoenix/workflows/Tests/badge.svg)

Inertiajs Adapter for Elixir Phoenix

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Installation](#installation)
- [Configuration](#configuration)
- [Render from Controller](#render-from-controller)
- [Pingcrm Example (wip)](#pingcrm-example-wip)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Installation

Add to mix.exs:
```
{:inertia_phoenix, "~> 0.1.3"}
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
      import InertiaPhoenix.Controller
    end
  end
```

## Configuration

Add to `config/config.exs`

```
config :inertia_phoenix,
  assets_version: 1
```

- Asset Versioning Docs: https://inertiajs.com/asset-versioning

## Render from Controller

NOTE: Flash data is automatically passed through to the page props.

```
def index(conn, _params) do
  render_inertia(conn, "Home", props: %{hello: "world"})

  # OR

  render_inertia(conn, "Home")
end
```

## Pingcrm Example (wip)

https://github.com/devato/pingcrm

