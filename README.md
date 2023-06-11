# README

Proof of concept for embedded markdown code blocks.

## Installation

Run

```
mix docs -f html
```

and enjoy

## Embedded code blocks

Embedded code blocks work also on plain markdown files
out of the box:

```embed::inspect
map = %{
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

Jason.encode!(map, pretty: true)
```
