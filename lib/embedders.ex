defmodule Embedders do
  @moduledoc false

  def vl(code, embedder, opts \\ []) do
    {plot, _} = Code.eval_string(code, [], __ENV__)

    case opts[:mode] do
      :details ->
        """
        The original embed fence:

        ~~~
        ```embed::#{embedder}
        #{code}
        ```
        ~~~

        Is translated to:

        > ```elixir
        #{String.split(code, "\n") |> Enum.map(fn line -> "> " <> line end) |> Enum.join("\n")}
        > ```
        >
        > ```vega-lite
        > #{Jason.encode!(plot)}
        > ```
        """

      _other ->
        """
        ```elixir
        #{code}
        ```

        ```vega-lite
        #{Jason.encode!(plot)}
        ```
        """
    end
  end

  def mermaid(code, _embedder, _opts \\ []) do
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

  def io_inspect(code, _embedder, _opts \\ []) do
    {result, _} = Code.eval_string(code, [], __ENV__)

    """
    ```elixir
    #{code}
    ```

    ```elixir
    #{result}
    ```
    """
  end
end
