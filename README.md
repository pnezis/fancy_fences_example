# About

An example using [`fancy_fences`](https://github.com/pnezis/fancy_fences) with various
fence processors defined.

## Installation

Run

```
mix docs -f html
```

and open the generated docs.

## Embedded code blocks

Embedded code blocks work also on plain markdown files out of the box.

### `inspect` processor

```inspect
person = %{
  name: "Test",
  age: 35,
  children: [
    %{
      name: "Bar"
    },
    %{
      name: "Baz"
    }
  ]
}

Map.put(person, "nationality", "Unknown")
|> List.duplicate(2)
```

### `markdown` processor

Autolinks should also work:

```markdown

```

### `vega-lite` processor

As well as vega lite plots (this is an example from `VegaLite` docs):

```vl
alias VegaLite, as: Vl

Vl.new()
|> Vl.data_from_url("https://vega.github.io/editor/data/weather.csv")
|> Vl.transform(filter: "datum.location == 'Seattle'")
|> Vl.concat([
  Vl.new()
  |> Vl.mark(:bar)
  |> Vl.encode_field(:x, "date", time_unit: :month, type: :ordinal)
  |> Vl.encode_field(:y, "precipitation", aggregate: :mean),
  Vl.new()
  |> Vl.mark(:point)
  |> Vl.encode_field(:x, "temp_min", bin: true)
  |> Vl.encode_field(:y, "temp_max", bin: true)
  |> Vl.encode(:size, aggregate: :count)
])
```
