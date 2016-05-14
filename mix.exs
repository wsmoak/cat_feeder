defmodule CatFeeder.Mixfile do
  use Mix.Project

  def project do
    [app: :cat_feeder,
     version: "0.0.1",
     elixir: "~> 1.1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :elixir_ale,
      :timex,
      # :nerves_io_ethernet,
      ],
     mod: {CatFeeder, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:elixir_ale, "~> 0.4.1"},
      {:exrm, "~> 1.0.0-rc7"},
      {:timex, "~> 2.1.4"},
      # {:nerves_io_ethernet, github: "nerves-project/nerves_io_ethernet"},
    ]
  end
end
