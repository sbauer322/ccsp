defmodule CCSP.Chapter3.Start do
  alias CCSP.Chapter3.CSP
  alias CCSP.Chapter3.QueensConstraint
  alias CCSP.Chapter3.MapColoringConstraint
  alias CCSP.Chapter3.WordSearch
  alias CCSP.Chapter3.WordSearchConstraint
  alias CCSP.Chapter3.SendMoreMoneyConstraint

  @moduledoc """
  Convenience module to for setting up and running more elaborate sections.
  """

  def run_map_coloring() do
    variables = [
      "Western Australia",
      "Northern Territory",
      "South Australia",
      "Queensland",
      "New South Wales",
      "Victoria",
      "Tasmania"
    ]

    domains =
      Enum.reduce(variables, %{}, fn variable, acc ->
        Map.put(acc, variable, ["red", "green", "blue"])
      end)

    csp = CSP.new(variables, domains)

    result =
      CSP.add_constraint(
        csp,
        MapColoringConstraint.new("Western Australia", "Northern Territory")
      )
      |> CSP.add_constraint(MapColoringConstraint.new("Western Australia", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("South Australia", "Northern Territory"))
      |> CSP.add_constraint(MapColoringConstraint.new("Queensland", "Northern Territory"))
      |> CSP.add_constraint(MapColoringConstraint.new("Queensland", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("Queensland", "New South Wales"))
      |> CSP.add_constraint(MapColoringConstraint.new("New South Wales", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("Victoria", "South Australia"))
      |> CSP.add_constraint(MapColoringConstraint.new("Victoria", "New South Wales"))
      |> CSP.add_constraint(MapColoringConstraint.new("Victoria", "Tasmania"))
      |> CSP.backtracking_search()

    result
  end

  def run_queens(n \\ 8) do
    columns = Enum.to_list(1..n)

    rows =
      Enum.reduce(columns, %{}, fn column, acc ->
        Map.put(acc, column, Enum.to_list(1..n))
      end)

    CSP.new(columns, rows)
    |> CSP.add_constraint(QueensConstraint.new(columns))
    |> CSP.backtracking_search()
    |> (&(if nil == &1 do
            {:error, "No solution found."}
          else
            &1
          end)).()
  end

  def run_word_search() do
    grid = WordSearch.generate_grid(9,9)
    words = ["MATTHEW", "JOE", "MARY", "SARAH", "SALLY"]

    locations =
      Enum.reduce(words, %{}, fn word, acc ->
        Map.put(acc, word, WordSearch.generate_domain(word, grid))
      end)

    solution =
      CSP.new(words, locations)
      |> CSP.add_constraint(WordSearchConstraint.new(words))
      |> CSP.backtracking_search()

    if nil == solution do
      {:error, "No solution found."}
    else
      {:ok, solution} = solution

      Enum.reduce(Map.to_list(solution), grid, fn {word, grid_locations}, acc ->
        # randomly reverse half the time
        # Enum.reverse(grid_locations)

        indexed_letters = Enum.zip(0..String.length(word), String.graphemes(word))

        Enum.reduce(indexed_letters, acc, fn {index, letter}, acc ->
          {row, column} =
            {Enum.at(grid_locations, index).row, Enum.at(grid_locations, index).column}

          List.update_at(
            acc,
            row,
            &List.update_at(
              &1,
              column,
              fn _ -> letter end
            )
          )
        end)
      end)
      |> WordSearch.display_grid()
    end
  end

  def run_send_more_money() do
    letters = ["S", "E", "N", "D", "M", "O", "R", "Y"]
    possible_digits = Enum.reduce(letters, %{}, fn letter, acc ->
      Map.put(acc, letter, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    end)
    possible_digits = Map.put(possible_digits, "M", [1])

    CSP.new(letters, possible_digits)
    |> CSP.add_constraint(SendMoreMoneyConstraint.new(letters))
    |> CSP.backtracking_search()
    |> (&(if nil == &1 do
         {:error, "No solution found."}
       else
         &1
       end)).()
  end
end
