defmodule NodepingPUSH.Modules.Memavail do
  @moduledoc """
  LINUX ONLY: Get the amount of available system memory
  """

  def main(_checkid) do
    memtypes = [:buffered_memory, :cached_memory, :free_memory]

    case :os.type() do
      {:unix, :linux} ->
        used_plus_caches =
          :memsup.get_system_memory_data()
          |> Enum.into(%{}, fn {k, v} -> {k, v} end)
          |> Map.take(memtypes)
          |> Map.values()
          |> Enum.reduce(0, fn x, acc -> x + acc end)

        {:memavial, div(used_plus_caches, 1_048_576)}

      {_, _} ->
        throw("#{__MODULE__} unsopported operating system type! Linux only module")
    end
  end
end
