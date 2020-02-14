defmodule Phoenertia.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenertia,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
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
      {:ex_doc, ">= 0.0.0"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
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
