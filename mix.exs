defmodule Advent.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Advent.Application, []}
    ]
  end

  defp deps do
    [
      {:nimble_parsec, "~> 0.4.0"}
    ]
  end
end
