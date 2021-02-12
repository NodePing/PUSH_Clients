defmodule NodepingPUSH.Modules.Ping do
  @moduledoc """
  Ping a list of hosts and return if they are
  up or down. This module returns % of packet loss
  """

  require Logger

  @moduleconfigs Application.compile_env!(:nodeping_push, :moduleconfigs)

  def main do
    configs =
      case File.read("#{@moduleconfigs}/ping.json") do
        {:ok, configs} ->
          Jason.decode!(configs, keys: :atoms)

        {:error, error} ->
          Logger.info("#{__MODULE__} error:\n#{error}")
          IO.inspect("#{@moduleconfigs}/ping.json")
          Process.exit(self(), :kill)
      end

    timeout = configs.timeout
    ping_count = configs.ping_count
    {_family, os} = :os.type()

    results =
      configs.hosts
      |> Enum.map(&Task.async(fn -> ping(&1, ping_count, timeout, os) end))
      |> Enum.map(&Task.await(&1, timeout * 1_000 + 1_000))
      |> Enum.into(%{})

    {:ping, results}
  end

  defp ping(host_info, ping_count, timeout, :freebsd) do
    host = host_info.host
    inet = host_info.inet

    case inet do
      4 ->
        String.split("ping -c #{ping_count} -t #{timeout} -q #{host}")

      6 ->
        String.split("ping -c #{ping_count} -t #{timeout} -q #{host}")
    end
    |> run(host)
    |> parse_ping(host, -7)
  end

  defp ping(host_info, ping_count, timeout, :linux) do
    host = host_info["host"]
    inet = host_info["inet"]

    case inet do
      4 ->
        String.split("ping -c #{ping_count} -W #{timeout} -q #{host}")

      6 ->
        String.split("ping -c #{ping_count} -W #{timeout} -q #{host}")
    end
    |> run(host)
    |> parse_ping(host, -10)
  end

  defp run(command, host) do
    [exec | args] = command

    case System.cmd(exec, args) do
      {result, 0} -> result
      {_error, 1} -> {host, 100}
    end
  end

  defp parse_ping(result, hostname, index) when is_bitstring(result) do
    packet_loss =
      result
      |> String.split(" ")
      |> Enum.at(index)
      |> String.replace("%", "")
      |> convert_to_int()

    {hostname, packet_loss}
  end

  defp parse_ping(result, _hostname, _index) when is_tuple(result) do
    result
  end

  defp convert_to_int(value) when is_bitstring(value) do
    case String.contains?(value, ".") do
      true ->
        value
        |> String.to_float()
        |> trunc()

      false ->
        value
        |> String.to_integer()
    end
  end
end
