defmodule CCSP.Chapter1.FibTest do
  use ExUnit.Case
  alias CCSP.Chapter1.Fib

  @moduledoc false

  test "expects known fib sequence values" do
    assert Fib.fib2(0) == 0
    assert Fib.fib2(1) == 1
    assert Fib.fib2(2) == 1
    assert Fib.fib2(3) == 2
    assert Fib.fib2(4) == 3
    assert Fib.fib2(5) == 5
    assert Fib.fib2(6) == 8
    assert Fib.fib2(7) == 13
    assert Fib.fib2(8) == 21
    assert Fib.fib2(9) == 34
    assert Fib.fib2(10) == 55
  end
end
