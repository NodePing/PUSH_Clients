defmodule NodepingPUSH.Modules.DiskData do
  @moduledoc """
  Get disk data per partition/mountpoint
  """

  def main(_checkid) do
    capacities =
      :disksup.get_disk_data()
      |> Enum.into(%{}, fn {mountpoint, _kbytes, capacity} -> {mountpoint, capacity} end)

    {:disk_data, capacities}
  end
end
