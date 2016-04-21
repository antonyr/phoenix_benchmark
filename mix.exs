defmodule PhoenixBenchmark.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_benchmark,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PhoenixBenchmark, []},
     applications: [:phoenix, :cowboy, :logger, :gettext, :httpoison, :dotenv, :httpotion]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:httpoison, "~> 0.8.0"},
     {:poison, "~> 2.1.0"},
     {:dotenv, "~> 2.0.0"},
     {:json,   "~> 0.3.0"},
     {:httpotion, "~> 2.2.0"}
   ]
  end
end