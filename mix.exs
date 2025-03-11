defmodule ElixirTemplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_template,
      version: "0.1.0",
      elixir: "~> 1.17",
      test_coverage: [summary: [threshold: calculate_threshold()]],
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        "test.watch": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ElixirTemplate.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:sourceror, "~> 1.7", only: [:dev, :test]},
      {:ash, "~> 3.0"},
      {:ash_phoenix, "~> 2.0"},
      {:ash_postgres, "~> 2.0"},
      {:ash_admin, "~> 0.13"},
      {:ash_authentication, "~> 4.0"},
      {:ash_authentication_phoenix, "~> 2.0"},
      {:bcrypt_elixir, "~> 3.0"},
      {:simple_sat, "~> 0.1.3"},
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: [:kind, :dev]},
      {:req, "~> 0.5.0"},
      {:phoenix_live_view, "~> 1.0.2", override: true},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() in [:dev, :kind]},
      {:tailwind, "~> 0.2", runtime: Mix.env() in [:dev, :kind]},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:fresh, "~> 0.4.4"},
      {:open_api_spex, "~> 3.16"},
      {:redoc_ui_plug, "~> 0.2"},
      {:plug_canonical_host, "~> 2.0"},
      {:cors_plug, "~> 3.0"},
      {:stream_data, "~> 1.1"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test]},
      {:phoenix_test, "~> 0.5.2", only: :test, runtime: false},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.24"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.2"},
      # Run all checks
      # https://github.com/karolsluszniak/ex_check
      {:ex_check, "~> 0.14.0", only: [:kind, :dev], runtime: false},
      # Code style, arch, problematic code, ...
      # https://github.com/rrrene/credo
      {:credo, "~> 1.7", only: [:dev, :test, :kind], runtime: false},
      # Security static analysis tool
      # https://github.com/nccgroup/sobelow
      {:sobelow, "~> 0.13", only: [:dev, :test, :kind], runtime: false},
      # Project documentation checks
      # https://github.com/akoutmos/doctor
      # TODO: configure doctor to ignore private functions and
      # allow leniency on @doc tags
      # {:doctor, "~> 0.21.0", only: [:dev, :test, :kind], runtime: false},
      # Audit dependencies for vulnerabilities
      # https://github.com/mirego/mix_audit
      {:mix_audit, "~> 2.1", only: [:dev, :test, :kind], runtime: false},
      # Test coverage
      # https://github.com/alfert/coverex
      {:coverex, "~> 1.4.10", only: :test},
      # Auto-refactoring utilities
      # https://github.com/hrzndhrn/recode
      # Generate module docs as an HTML file for easier reading by running "mix docs"
      {:ex_doc, "~> 0.25", only: [:kind, :dev], runtime: false},
      {:cloak, "~> 1.1"},
      {:styler, "~> 0.11", only: [:dev, :test, :kind], runtime: false},
      {:ecto_psql_extras, "~> 0.7"},
      # Telemetry for prometheus
      {:telemetry_metrics_prometheus_core, "~> 1.1"},
      # Telemetry for Distributed Tracing
      {:opentelemetry_exporter, "~> 1.7"},
      {:opentelemetry, "~> 1.4"},
      {:opentelemetry_ecto,
       git: "https://github.com/open-telemetry/opentelemetry-erlang-contrib",
       tag: "opentelemetry-telemetry-v1.1.2",
       sparse: "instrumentation/opentelemetry_ecto"},
      {:opentelemetry_liveview, "~> 1.0.0-rc.4"},
      {:opentelemetry_bandit,
       git: "https://github.com/open-telemetry/opentelemetry-erlang-contrib",
       tag: "opentelemetry-telemetry-v1.1.2",
       sparse: "instrumentation/opentelemetry_bandit"},
      {:opentelemetry_phoenix,
       git: "https://github.com/open-telemetry/opentelemetry-erlang-contrib",
       tag: "opentelemetry-telemetry-v1.1.2",
       sparse: "instrumentation/opentelemetry_phoenix"},
      {:opentelemetry_finch,
       git: "https://github.com/open-telemetry/opentelemetry-erlang-contrib",
       tag: "opentelemetry-telemetry-v1.1.2",
       sparse: "instrumentation/opentelemetry_finch"},
      {:timex, "~> 3.7"},
      {:poison, "~> 3.0"},
      {:hackney, "~> 1.9"},
      {:igniter, "~> 0.5", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "test.run": [&run_test/1],
      "test.clean": [&clean_test/1],
      setup: [
        "deps.get",
        "deps.compile",
        &npm_ci/1,
        "assets.setup",
        "assets.build",
        "ash.setup",
        "compile",
        "run priv/repo/seeds.exs"
      ],
      "ecto.setup": ["ash.setup", "ash.migrate"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "user.seed": ["run priv/repo/seeds/user_data_seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": [
        "tailwind.install --if-missing",
        "esbuild.install --if-missing"
      ],
      "assets.build": ["tailwind elixir_template", "esbuild elixir_template"],
      "assets.deploy": [
        "tailwind elixir_template --minify",
        "esbuild elixir_template --minify",
        "phx.digest"
      ],
      clear: ["deps.unlock --unused", "clean --unused"],
      "gen.env": ["deps.get", "gen_env"],
      "gen.lang": [&gen_lang/1],
      "gen.translate": [&gen_translate/1],
      ugh: [&just_work_please/1],
      "phx.routes": ["phx.routes", "ash_authentication.phoenix.routes"]
    ]
  end

  defp npm_ci(_args) do
    Mix.shell().cmd("npm ci --prefix ./assets")
  end

  @spec gen_lang(args :: Optional.t(List.t(String.t()))) :: :ok
  defp gen_lang(args) do
    Mix.Task.run("gettext.extract")
    Mix.Task.run("gettext.merge", ["priv/gettext"])

    if length(args) > 0,
      do:
        Enum.each(args, fn arg ->
          Mix.Task.run("gettext.merge", ["priv/gettext", "--locale #{arg}"])
        end)
  end

  @spec gen_translate(args :: Optional.t(List.t(String.t()))) :: :ok
  defp gen_translate(args) do
    Mix.Task.run("translate", args)
  end

  defp run_test(_) do
    Mix.shell().cmd("docker compose -f test.docker-compose.yml up --build")
  end

  defp clean_test(_) do
    Mix.shell().cmd("docker compose -f test.docker-compose.yml down -v")
  end

  defp just_work_please(_) do
    Mix.shell().cmd("rm -rf _build")
    Mix.shell().cmd("rm -rf deps")
    Mix.shell().cmd("mix do clear, deps.get, deps.compile, compile")
  end

  def calculate_threshold do
    # Increase this cap to 80% if ctf gets funded
    max_threshold = 60

    day_we_start_counting = ~D[2025-02-28]
    diff = Date.diff(Date.utc_today(), day_we_start_counting)

    if(diff > 0) do
      # increase our test coverage threshold by 10% every month, up to max_threshold.
      months_since_starting = div(diff, 30)

      min(20 + 10 * months_since_starting, max_threshold)
    else
      0
    end
  end
end
