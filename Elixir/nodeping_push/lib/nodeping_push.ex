defmodule NodepingPUSH do
  @moduledoc """
  Documentation for `NodepingPUSH`.
  """

  use GenServer
  require Logger

  @name __MODULE__
  @config_file Application.compile_env!(:nodeping_push, :config_file)

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: @name)
  end

  def test_get_configs do
    GenServer.call(@name, :test_get_configs)
  end

  def run_jobs(interval) do
    GenServer.cast(@name, {:run_jobs, interval})
  end

  @impl true
  def init(default) do
    {:ok, default}
  end

  @impl true
  def handle_call(:test_get_configs, _from, state) do
    {:reply, read_config_file(), state}
  end

  @impl true
  def handle_cast({:run_jobs, interval}, state) do
    configs = read_config_file()

    # {"data":{"pingstatus":{ "wa1.nodeping.com":1}}}
    configs
    |> Map.get(:jobs)
    |> Enum.filter(fn x -> Map.get(x, :interval) == interval end)
    |> Enum.map(&Task.async(fn -> run_parent_module(&1) end))
    |> Enum.map(&Task.await(&1, 12_000))

    {:noreply, state}
  end

  defp read_config_file do
    case File.read(@config_file) do
      {:ok, result} ->
        case Jason.decode(result, keys: :atoms) do
          {:ok, decoded} -> decoded
          {:error, error} -> error
        end

      {:error, error} ->
        error
    end
  end

  defp run_parent_module(job) do
    configs = read_config_file()
    checkid = job.checkid
    checktoken = job.checktoken
    url = generate_url(checkid, checktoken)

    results =
      job
      # List of modules to run
      |> Map.get(:modules)
      |> Enum.map(&Task.async(fn -> run_module(&1) end))
      |> Enum.map(&Task.await(&1, 10_000))
      # Will have [{:hello_world, 1}, {:hello_world2, 1}]
      |> Enum.into(%{})

    # Log and submit the results if true
    submit_results(url, %{:data => results}, checkid, Map.get(configs, :submit_results))
  end

  defp run_module(module) do
    apply(
      String.to_existing_atom("Elixir.#{module}"),
      :main,
      []
    )
  end

  defp submit_results(url, results, checkid, to_post) do
    case to_post do
      true ->
        Logger.info("Data to submit for #{checkid}: #{inspect(results)}", level: :info)
        post(url, checkid, results)

      false ->
        Logger.info("<<<TEST Data to submit for #{checkid}: #{inspect(results)}>>>", level: :info)
    end
  end

  defp post(url, checkid, payload) do
    json_payload = Jason.encode!(payload)
    headers = ["Content-Type": "application/json"]

    case HTTPoison.post(url, json_payload, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info("200 #{checkid}: #{body}")

      {:ok, %HTTPoison.Response{status_code: 409, body: body}} ->
        Logger.info("409 #{checkid}: #{body}")

      {:ok, %HTTPoison.Response{status_code: 403, body: body}} ->
        Logger.info("403 #{checkid}: #{body}")

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info("#{checkid} 404 Not found")
    end
  end

  defp generate_url(checkid, checktoken) do
    "https://push.nodeping.com/v1?id=#{checkid}&checktoken=#{checktoken}"
  end
end
