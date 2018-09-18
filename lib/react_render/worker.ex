defmodule ReactRender.Worker do
  use GenServer

  @moduledoc """
  A genserver that controls the starting of the node render service
  """

  @doc """
  Starts the ReactRender and underlying node react render service.
  """
  @spec start_link([binary()]) :: {:ok, pid} | {:error, any()}
  def start_link([render_service_path]) do
    GenServer.start_link(__MODULE__, render_service_path)
  end

  # --- GenServer Callbacks ---
  @doc false
  def init(render_service_path) do
    node = System.find_executable("node")

    port = Port.open({:spawn_executable, node}, [:stderr_to_stdout, :binary, :exit_status, args: [render_service_path]])

    {:ok, [render_service_path, port]}
  end

  @doc false
  def handle_call({:html, component, props}, _from, state = [_, port]) do
    body =
      Jason.encode!(%{
        component: component,
        props: props,
      })

    Port.command(port, body <> "\n")

    response = retreive_data(port)
    
    {:reply, response, state}
  end

  @doc false
  def terminate(_reason, [_, port]) do
    send(port, {self(), :close})
  end

  defp retreive_data(port, chunks \\ <<>>) do
    receive do
      {^port, {:data, data}} ->
        completed = String.ends_with?(data, "\"Wall\"}")
        chunks = chunks <> data
        if (completed) do
          Jason.decode!(chunks)
        else
          retreive_data(port, chunks)
        end
    end
  end
end
