# Inertia Phoenix

![CI](https://github.com/devato/inertia_phoenix/workflows/CI/badge.svg)

Inertiajs Adapter for Elixir Phoenix

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Installation](#installation)
- [Configuration](#configuration)
- [Render from Controller](#render-from-controller)
- [Features](#features)
- [In progress:](#in-progress)
- [Pingcrm Example (wip)](#pingcrm-example-wip)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

Add to mix.exs:
```
{:inertia_phoenix, "~> 0.1.6"}
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
  assets_version: 1,          # default 1
  inertia_layout: "app.html"  # default app.html
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

## Layout/Templates

- Doesn't require templates as Inertia Pages are templates.
- `div#app` is rendered automatically.

An example layout:

```
<!DOCTYPE html>
<html lang="en">
  <head>
    ...
  </head>
  <body>
    <%= render @view_module, @view_template, assigns %>
    <script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/app.js") %>"></script>
  </body>
</html>
```

## Configure Axios

`XSRF-TOKEN` cookie is set automatically.

To configure axios to use it by default, in `app.js`
```
import axios from "axios";
axios.defaults.xsrfHeaderName = "x-csrf-token";
```

## Features

- Render React/Vue/Svelte from controllers
- Flash data pass to props via Plug
- Assets Versioning: https://inertiajs.com/asset-versioning
- Auto put response cookie for crsf token: https://inertiajs.com/security#csrf-protection
- Override redirect codes: https://inertiajs.com/redirects#303-response-code

## In progress:

- Documentation
- Shared data interface: https://inertiajs.com/shared-data
- Partial reloads: https://inertiajs.com/requests#partial-reloads

## Pingcrm Example (wip)

https://github.com/devato/pingcrm

