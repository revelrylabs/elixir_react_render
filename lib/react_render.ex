defmodule ReactRender do
  use Supervisor

  @timeout 10_000
  @default_pool_size 4

  @moduledoc """
  React Renderer
  """

  @doc """
  Starts the ReactRender and workers.

  ## Options
    * `:path` - (required) is the path to the react render service relative
  to your current working directory
    * `:pool_size` - (optional) the number of workers. Defaults to 4
  """
  @spec start_link(keyword()) :: {:ok, pid} | {:error, any()}
  def start_link(args) do
    default_options = [
      pool_size: @default_pool_size,
      timeout: 60_000,
      path: Path.join(:code.priv_dir(:react_render), "nodejs")
    ]

    opts = Keyword.merge(default_options, hd(args))

    children = [
      supervisor(NodeJS.Supervisor, [opts])
    ]

    supervisor_opts = Keyword.merge([strategy: :one_for_one, name: __MODULE__], opts)
    Supervisor.start_link(children, supervisor_opts)
  end

  @doc """
  Stops the ReactRender and underlying node react render service
  """
  @spec stop() :: :ok
  def stop() do
    Supervisor.stop(__MODULE__)
  end

  @doc """
  Given the `component_path` and `props`, returns html.

  `component_path` is the path to your react component module relative
  to the render service.

  `props` is a map of props given to the component. Must be able to turn into
  json
  """
  @spec get_html(binary(), map()) :: {:ok, binary()} | {:error, map()}
  def get_html(component_path, props \\ %{}) do
    case do_get_html(component_path, props) do
      {:error, _} = error ->
        error

      {:ok, %{"markup" => markup}} ->
        {:ok, markup}
    end
  end

  @doc """
  Same as `get_html/2` but wraps html in a div which is used
  to hydrate react component on client side.

  This is the preferred function when using with Phoenix

  `component_path` is the path to your react component module relative
  to the render service.

  `props` is a map of props given to the component. Must be able to turn into
  json
  """
  @spec render(binary(), map()) :: {:safe, binary()}
  def render(component_path, props \\ %{}) do
    case do_get_html(component_path, props) do
      {:error, %{message: message, stack: stack}} ->
        raise ReactRender.RenderError, message: message, stack: stack

      {:ok, %{"markup" => markup, "component" => component}} ->
        props =
          props
          |> Jason.encode!()
          |> String.replace("\"", "&quot;")

        html =
          """
          <div data-rendered data-component="#{component}" data-props="#{props}">
          #{markup}
          </div>
          """
          |> String.replace("\n", "")

        {:safe, html}
    end
  end

  defp do_get_html(component_path, props) do
    NodeJS.call(
      {:server, :makeHtml},
      %{path: component_path, props: props}
    )
  end
end
