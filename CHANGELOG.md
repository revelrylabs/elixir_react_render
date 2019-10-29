# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2019-10-29

### Changed

- **BREAKING**: Configuration now takes a path for `render_service_path` instead of a file.

  Before:
  ```elixir
  render_service_path = "assets/js/server.js"
  supervisor(ReactRender, [render_service_path: render_service_path])
  ```

  After:
  ```elixir
  render_service_path = "assets"
  supervisor(ReactRender, [render_service_path: render_service_path])
  ```

- **BREAKING**: Use `assets/render_server.js` as the main render server and configuration file. Refer to "Getting Started with Phoenix" section in `README.md` for details.
- React/ReactDOM are now peer dependencies

### Added

- Ability to configure Babel plugins

### Fixed

- Render unicode characters properly

## [2.0.1] - 2018-09-25

### Fixed

- Make sure server uses the correct babel preset

## [2.0.0] - 2018-07-26

### Changed

- **BREAKING**: ReactRender.render/2 now returns `{:safe, html}` so that calls to `raw` in phoenix are no longer needed
- **BREAKING**: Configuration now takes a keyword list.

  Before:

  ```elixir
    render_service_path = "assets/js/server.js"
    worker(ReactRender, [render_service_path])
  ```

  After:

  ```elixir
    render_service_path = "assets/js/server.js"
    supervisor(ReactRender, [render_service_path: render_service_path])
  ```

### Added

- ReactRender is now a supervisor
- `pool_size` option to control the number of renderers

## [1.0.0] - 2018-06-12

### Added

- ReactRender.get_html/2
- ReactRender.render/2
