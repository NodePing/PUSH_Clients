defmodule NodepingPUSH.Modules.HelloWorld do
  @moduledoc """
  This module simply returns {:hello_world, 1}
  """

  def main(_checkid) do
    {:hello_world, 1}
  end
end
