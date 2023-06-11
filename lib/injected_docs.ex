defmodule InjectedDocs do
  @moduledoc """
  Documentation for `InjectedDocs`.
  """

  alias VegaLite, as: Vl

  @doc """
  Dummy scatter plot.

  Notice that it contains an `embed` fenced block which will

  * Evaluate the inline code during docs generation
  * Replace it with
    * A fenced `elixir` block containing the input code
    * A fenced `vega-lite` block for displaying the graph

  ```embed::vl
  InjectedDocs.scatter("petal_width", "petal_length")
  |> VegaLite.to_spec()
  ```

  You can add any valid elixir code in the fences as long as it returns
  a valid VegaLite map. Also embedders can support options which can modify
  the appearence of the output. For example:

  ```embed::vl-details
  alias VegaLite, as: Vl

  x = "petal_width"
  y = "sepal_width"

  InjectedDocs.scatter(x, y)
  |> Vl.encode_field(:color, "species", [])
  |> Vl.to_spec()
  ```
  """
  def scatter(x, y) do
    VegaLite.new()
    |> Vl.data_from_url(iris())
    |> Vl.mark(:point, [])
    |> Vl.encode_field(:x, x, type: :quantitative)
    |> Vl.encode_field(:y, y, type: :quantitative)
  end

  defp iris do
    "https://gist.githubusercontent.com/curran/a08a1080b88344b0c8a7/raw/0e7a9b0a5d22642a06d3d5b9bcbad9890c8ee534/iris.csv"
  end

  @doc """
  Converts a `:digraph` to a mermaid flowchart

  ## Example

  ```embed::mermaid
  # Let's create a simple graph first
  graph = :digraph.new()

  :digraph.add_vertex(graph, :a)
  :digraph.add_vertex(graph, :b)
  :digraph.add_vertex(graph, :c)
  :digraph.add_vertex(graph, :d)

  :digraph.add_edge(graph, :a, :b)
  :digraph.add_edge(graph, :a, :c)
  :digraph.add_edge(graph, :b, :d)
  :digraph.add_edge(graph, :d, :a)
  :digraph.add_edge(graph, :d, :c)

  # Use digraph_to_mermaid/1 to convert it to mermaid chart
  InjectedDocs.digraph_to_mermaid(graph)
  ```
  """
  def digraph_to_mermaid(graph) do
    vertices =
      :digraph.vertices(graph)
      |> Enum.map(fn v -> "  #{v}" end)
      |> Enum.join("\n")

    edges =
      :digraph.edges(graph)
      |> Enum.map(fn edge ->
        {_e, v1, v2, _l} = :digraph.edge(graph, edge)
        {v1, v2}
      end)
      |> Enum.map(fn {v1, v2} -> "  #{v1} --> #{v2}" end)
      |> Enum.join("\n")

    """
    flowchart TD
    #{vertices}

    #{edges}
    """
  end
end
