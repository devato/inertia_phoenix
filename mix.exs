defmodule InertiaPhoenix.MixProject do
  use Mix.Project

  def project do
    [
      app: :inertia_phoenix,
      version: "0.1.2",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix] ++ Mix.compilers(),
      deps: deps(),
      description: "Inertiajs adapter for Elixir Phoenix",
      package: package()
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
      {:phoenix, "~> 1.3.0 or ~> 1.4.0"},
      {:phoenix_html, ">= 2.0.0 and <= 3.0.0"},
      {:plug, ">= 1.5.0 and < 2.0.0", optional: true},
      {:credo, "~> 1.2.0", only: [:dev, :test]},
      # Credo requires jason to exist also in :dev
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.21.0", only: :dev},
      {:plug_cowboy, "~> 2.1", only: [:test]}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Troy Martin"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/devato/inertia_phoenix"},
      files: ~w(lib LICENSE.txt mix.exs README.md)
    ]
  end
end
