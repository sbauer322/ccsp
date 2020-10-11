# CCSP in Elixir

This project contains selected problems from the book "Classical Computer Science Problems in Python" translated into Elixir.

For comparison, the source code for CCSP in Python can be found [on Github](https://github.com/davecom/ClassicComputerScienceProblemsInPython).

There are a handful of goals:

- Demonstrate an idiomatic Elixir approach to the problems found in the book
- Showcase differences between programming paradigms as represented by the two languages
- Provide in-depth explanations of each section via [blog posts](https://bauerspace.com)
- Minimize the use of external libraries that would do the "heavy lifting" for a solution

If you spot an error, typo, or better approach to a solution, feel free to reach out via creating an Issue or PR.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ccsp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ccsp, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ccsp](https://hexdocs.pm/ccsp).

## Handy Commands

```
iex -S mix
mix deps.get
mix test
mix dialyzer
mix format
```

