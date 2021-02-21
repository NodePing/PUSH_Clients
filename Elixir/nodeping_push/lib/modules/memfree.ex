defmodule NodepingPUSH.Modules.Memfree do
  @moduledoc """
  Get the amount of free memory on the system
  """

  def main(_checkid) do
    meminfo =
      :memsup.get_system_memory_data()
      |> Enum.into(%{}, fn {k, v} -> {k, v} end)
      |> Map.get(:free_memory)
      |> div(1_048_576)

    {:memfree, meminfo}
  end
end
