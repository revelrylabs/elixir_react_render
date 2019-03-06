# ReactRender

[![Build Status](https://travis-ci.org/revelrylabs/elixir_react_render.svg?branch=master)](https://travis-ci.org/revelrylabs/elixir_react_render)
[![Hex.pm](https://img.shields.io/hexpm/dt/react_render.svg)](https://hex.pm/packages/react_render)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Coverage Status](https://coveralls.io/repos/github/revelrylabs/elixir_react_render/badge.svg)](https://coveralls.io/github/revelrylabs/elixir_react_render)

Renders React as HTML

# Documentation

The docs can
be found at [https://hexdocs.pm/react_render](https://hexdocs.pm/react_render).

## Installation

```elixir
def deps do
  [
    {:react_render, "~> 2.0.3"}
  ]
end
```

## Getting Started with Phoenix

- Add `react_render` to your dependencies in package.json

```js
"react_render": "file:../deps/react_render"
```

- Run `npm install`

```bash
npm install
```

- Create a file named `server.js` in your `assets/js` folder and add the following

```js
const ReactRender = require('react_render/priv/server')

ReactRender.startServer()
```

- Add `ReactRender` to your Supervisor as a child. We're using the absolute path to be sure where the file is.

```elixir
  render_service_path = "#{File.cwd!}/assets/js/server.js"

  supervisor(ReactRender, [[render_service_path: render_service_path, pool_size: 4]])
```

# Working with Webpack
Since the new version of Phoenix uses Webpack as the asset builder, we're going to leverage webpack features for our components.

You need to add `React` and `react-dom` packages as your dependencies and these packages should be global so your application can render the components server side.

## Make sure React and React-DOM are installed

```
# using npm
npm install react react-dom --save
```

```
# using yarn
yarn add react react-dom
```

## Create an entry point on your webpack config
For you to leverage caching and `react` as a global package so you don't need to import on each component, we advise you to create a file like `vendor.js` where this file will only contain you common packages that you would use on every component.

Could be `react`, `jquery`, etc.
In this case, we only need `react` and `react-dom`.

```javascript
entry: {
  'js/vendor': path.resolve(__dirname, './js/vendor')
},
```

## Create a vendor file and import on your phoenix template
```javascript
// vendor.js
import React from 'react';
import ReactDOM from 'react-dom';

const jQuery = (window.jQuery = window.$ = require('jquery'));

global.React = React;
global.ReactDOM = ReactDOM;
```

```elixir
# index.html.eex
<script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/vendor.js") %>"></script>
```

## Create a react component like:

```javascript
class HelloWorld extends React.Component {
  render() {
    const { name } = this.props;

    return <div>Hello {name}</div>
  }
}

export default HelloWorld;
```

## Call `ReactRender.render/2` inside your template where you want to add your react component

```elixir
<div>
  <%= ReactRender.render("#{File.cwd!}/assets/js/components/Home/index.jsx") %>
</div>
```

`component_path` can either be an absolute path or one relative to the render service. The stipulation is that components must be in the same path or a sub directory of the render service. This is so that the babel compiler will be able to compile it. The service will make sure that any changes you make are picked up. It does this by removing the component_path from node's `require` cache. If do not want this to happen, make sure to add `NODE_ENV` to your environment variables with the value `production`.

- To hydrate server-created components in the client, add the following to your `app.js`

## Hydrate your server-created components in the client
We advise you to create a javascript file for each template where you will render server side react components and add as a webpack entry because this will be the file where you will import all of your components for that specific view.

With this strategy, you only import and send to the client code that you will use.

The folder structure for javascript files would be like:
```
assets
  js
    components
      HelloWorld
        index.jsx
    views
      Home
        index.js
    app.js (if you need)
    vendor.js
    server.js
```

```javascript
// views/Home/index.js

import { hydrateClient } from 'react_render/priv/client';
import HelloWorld from './components/HelloWorld/index.js';

function getComponentFromStringName(stringName) {
  // Map string component names to your react components here
  if (stringName === 'HelloWorld') {
    return HelloWorld
  }

  return null
}

hydrateClient(getComponentFromStringName)
```

### Add as a webpack entry
```javascript
entry: {
  'js/vendor': path.resolve(__dirname, './js/vendor'),
  'js/home': path.resolve(__dirname, './js/views/Home'),
},
```

### Import in the view that will render SS react components
```elixir
# index.html.eex
<script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/vendor.js") %>"></script>
<script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/home.js") %>"></script>
```
