defmodule CatFeeder.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :cat_feeder,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.1"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [
      :logger,
      :nerves_interim_wifi,
      :elixir_ale,
      :gpio_rpi,
      :timex,
      :persistent_storage,
      :cat_feeder_web,
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
      {:exrm, "~> 1.0.5"},
      {:timex, "3.0.8"},
      {:nerves, "~> 0.3"},
      {:persistent_storage, git: "https://github.com/cellulose/persistent_storage.git", branch: "master"},
      {:gpio_rpi, git: "https://github.com/Hermanverschooten/gpio_rpi.git", branch: "master"},
      {:nerves_interim_wifi, "~> 0.0.2"},
      {:cat_feeder_web, in_umbrella: true},
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
