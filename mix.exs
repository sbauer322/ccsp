defmodule CCSP.MixProject do
  use Mix.Project

  def project do
    [
      app: :ccsp,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.19"},
      {:earmark, "~> 1.2.4"},
      {:stream_data, "~> 0.1", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp escript_config do
    [
      main_module: Weather.CLI
    ]
  end
end
