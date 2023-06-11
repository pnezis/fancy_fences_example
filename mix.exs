defmodule InjectedDocs.MixProject do
  use Mix.Project

  def project do
    [
      app: :injected_docs,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
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
      # {:ex_doc, path: "../ex_doc", only: :dev, runtime: false},
      {:ex_doc, github: "pnezis/ex_doc", branch: "poc-embed-code", only: :dev, runtime: false},
      {:vega_lite, "~> 0.1.7"},
      {:jason, "~> 1.3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp docs do
    [
      extras: [
        "README.md"
      ],
      embedders: [
        inspect: {Embedders, :io_inspect, []},
        vl: {Embedders, :vl, []},
        "vl-details": {Embedders, :vl, [mode: :details]},
        mermaid: {Embedders, :mermaid, []}
      ],
      before_closing_body_tag: fn
        :html ->
          """
          <script src="https://cdn.jsdelivr.net/npm/vega@5.20.2"></script>
          <script src="https://cdn.jsdelivr.net/npm/vega-lite@5.1.1"></script>
          <script src="https://cdn.jsdelivr.net/npm/vega-embed@6.18.2"></script>
          <script>
            document.addEventListener("DOMContentLoaded", function () {
              for (const codeEl of document.querySelectorAll("pre code.vega-lite")) {
                try {
                  const preEl = codeEl.parentElement;
                  const spec = JSON.parse(codeEl.textContent);
                  const plotEl = document.createElement("div");
                  preEl.insertAdjacentElement("afterend", plotEl);
                  vegaEmbed(plotEl, spec);
                  preEl.remove();
                } catch (error) {
                  console.log("Failed to render Vega-Lite plot: " + error)
                }
              }
            });
          </script>
          <script src="https://cdn.jsdelivr.net/npm/mermaid@8.13.3/dist/mermaid.min.js"></script>
          <script>
            document.addEventListener("DOMContentLoaded", function () {
              mermaid.initialize({ startOnLoad: false });
              let id = 0;
              for (const codeEl of document.querySelectorAll("pre code.mermaid")) {
                const preEl = codeEl.parentElement;
                const graphDefinition = codeEl.textContent;
                const graphEl = document.createElement("div");
                const graphId = "mermaid-graph-" + id++;
                mermaid.render(graphId, graphDefinition, function (svgSource, bindListeners) {
                  graphEl.innerHTML = svgSource;
                  bindListeners && bindListeners(graphEl);
                  preEl.insertAdjacentElement("afterend", graphEl);
                  preEl.remove();
                });
              }
            });
          </script>
          """

        _ ->
          ""
      end
    ]
  end
end
