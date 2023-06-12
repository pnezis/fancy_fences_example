defmodule FenceProcessors do
  @moduledoc """
  Implementation of some sample processors for enhancing your docs
  """

  @doc """
  A fence processor for documenting fence processors usage.
  """
  def fence_processor_doc(code) do
    """
    #### Embedded code

    A fenced code block of the form:

    ~~~elixir
    #{code}
    ~~~

    will be transformed to:

    #{code}
    """
  end

  @doc """
  Embeds the original code and the evaluated result.

  ~~~fence_processor
  ```inspect
  Enum.map([1, 2, 3], fn x -> 2*x end)
  ```
  ~~~
  """
  def io_inspect(code) do
    {result, _} = Code.eval_string(code, [], __ENV__)

    """
    ```elixir
    #{code}
    ```

    ```elixir
    #{inspect(result, pretty: true)}
    ```
    """
  end

  @doc """
  Embeds `NimbleOptions` docs

  It expects the input to be a valid `NimbleOptions` schema.


  ~~~fence_processor
  ```nimble_options
  [
    name: [
      required: true,
      type: :string,
      doc: "A name"
    ]
  ]
  ```
  ~~~
  """
  def nimble_options(code) do
    {schema, _} = Code.eval_string(code, [], __ENV__)

    NimbleOptions.docs(schema)
  end

  @doc """
  Renders the original code and the vega-lite json spec

  It expects the input to be a `%VegaLite{}` struct.
  """
  def vl(code, _opts \\ []) do
    {%VegaLite{} = plot, _} = Code.eval_string(code, [], __ENV__)

    spec = VegaLite.to_spec(plot)

    """
    ```elixir
    #{code}
    ```

    ```vega-lite
    #{Jason.encode!(spec)}
    ```
    """
  end

  def mermaid(code) do
    {mermaid, _} = Code.eval_string(code, [], __ENV__)

    """
    ```elixir
    #{code}
    ```

    ```mermaid
    #{mermaid}
    ```
    """
  end

  def markdown(_code) do
    """
    Fence processors can return **plain** `markdown`, similarly to
    elixir docs. 

    Autolinks will be properly created:

      * `FenceProcessors.nimble_options/1`

    They can also include other fence processors which will be
    embedded:

    ### Example

    ```inspect
    x = 1
    y = 2

    Enum.map([1, 2, 3], fn item -> item*y + x end)
    ```

    But no recursion is allowed:

    ```markdown
    Some text
    ```
    """
  end
end
