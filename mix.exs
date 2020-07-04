defmodule Tgdb.MixProject do
  use Mix.Project

  def project do
    [
      app: :tgdb,
      description: "Elixir wrapper for TheGamesDB API. https://api.thegamesdb.net/",
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Joshua Rieken"],
      licenses: ["MIT"],
      links: %{Github: "https://github.com/facto/tgdb"}
    ]
  end

  def docs do
    [
      readme: "README.md",
      main: Tgdb
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :test]}
    ]
  end
end
