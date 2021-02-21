defmodule NodepingPUSH.Modules.Loadavg do
  @moduledoc """
  Gets the operating system's load average and returns
  data like {":1min": 1, ":5min": 1, ":15min": 1}
  """

  def main(_checkid) do
    one_min =
      (:cpu_sup.avg1() / 256)
      |> Float.round(2)

    five_min =
      (:cpu_sup.avg5() / 256)
      |> Float.round(2)

    fifteen_min =
      (:cpu_sup.avg15() / 256)
      |> Float.round(2)

    {:loadavg, %{:"1min" => one_min, :"5min" => five_min, :"15min" => fifteen_min}}
  end
end
