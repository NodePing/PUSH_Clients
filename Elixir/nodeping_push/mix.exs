defmodule NodepingPUSH.MixProject do
  use Mix.Project

  def project do
    [
      app: :nodeping_push,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NodepingPUSH.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:quantum, "~> 3.3"},
      {:logger_file_backend, "~> 0.0.11"},
      {:credo, "~> 1.5"}
      # Module deps go here
    ]
  end
end
