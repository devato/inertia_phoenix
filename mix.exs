defmodule IntertiaPhoenix.MixProject do
  use Mix.Project

  def project do
    [
      app: :inertia_phoenix,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix] ++ Mix.compilers(),
      deps: deps(),
      description: description(),
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

  defp description do
    """
    Library for using InertiaJS with Phoenix
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Troy Martin"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kkempin/exiban"}
    ]
  end
end
