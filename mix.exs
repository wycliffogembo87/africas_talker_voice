defmodule AfricasTalkerSms.MixProject do
  use Mix.Project

  def project do
    [
      app: :africas_talker_sms,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    An Elixir based Africastalking SMS API Wrapper.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      maintainers: ["Wycliff Ogembo"],
      licenses: ["Apache License 2.0"],
      links: %{"GitHub" => "https://github.com/wycliffogembo87/africas_talker_sms"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :poolboy, :httpoison],
      mod: {AfricasTalkerSms.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:poolboy, "~> 1.5.2"},
      {:httpoison, "~> 1.5.1"},
      {:poison, "~> 4.0.1"},
      {:ex_doc, "~> 0.21.1"}
    ]
  end
end
