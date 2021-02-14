defmodule NodepingPUSH.Modules.Loadavg do
  @moduledoc """
  Gets the operating system's load average and returns
  data like {":1min": 1, ":5min": 1, ":15min": 1}
  """

  def main(_checkid) do
    loads =
      case :os.type() do
        {:unix, :freebsd} ->
          get_load(:freebsd)

        {:unix, :linux} ->
          get_load(:linux)
      end

    {:loadavg, loads}
  end

  defp get_load(:freebsd) do
    {result, 0} = System.cmd("sysctl", ["vm.loadavg"])
    split = String.split(result)

    Enum.map(2..4, fn x -> Enum.at(split, x) end)
    |> (&Enum.zip([:"1min", :"5min", :"15min"], &1)).()
    |> Enum.into(%{})
  end

  defp get_load(:linux) do
    case System.cmd("cat", ["/proc/loadavg"]) do
      {result, 0} ->
        split = String.split(result)

        Enum.map(0..2, fn x -> Enum.at(split, x) end)
        |> (&Enum.zip([:"1min", :"5min", :"15min"], &1)).()
        |> Enum.into(%{})

      {_result, 1} ->
        %{:"1min" => 10_000, :"5min" => 10_000, :"15min" => 10_000}
    end
  end
end
