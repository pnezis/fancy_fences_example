defmodule Sample do
  @moduledoc """
  A sample module using fence processors all over the place.

  ## Inspect processor

  You can use `inspect` processor to print the result of an
  elixir code snippet.

  Within am admonition block:

  > #### `inspect` Example {: .info}
  >
  > ```inspect
  > list = [1, 2, 3, 4]
  > Sample.update_list(list)
  > ```


  This is useful:

  - In plain markdown files
  - When you want to provide examples of the current module's function
  and normal interpolation does not work.
  """

  @doc false
  def update_list(list) do
    Enum.map(list, fn x -> 2 * x end)
  end

  @doc """
  A `NimbleOptions` schema

  ```nimble_options
  Sample.schema()
  ```
  """
  def schema do
    [
      name: [
        required: true,
        type: :atom,
        doc: "See also `echo_name/1`"
      ]
    ]
  end

  @doc """
  My dummy function
  """
  def echo_name(name) do
    name
  end

  alias VegaLite, as: Vl

  @doc """
  An iris scatter plot

  ```vl
  alias VegaLite, as: Vl

  x = "petal_width"
  y = "sepal_width"

  Sample.scatter(x, y)
  |> Vl.encode_field(:color, "species", [])
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

  ```mermaid
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
  Sample.digraph_to_mermaid(graph)
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

  @doc """
  ```markdown
  ```
  """
  def foo, do: 1
end
