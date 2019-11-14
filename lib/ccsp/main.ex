defmodule Main do
  alias CCSP.Chapter1.Start, as: Start1
  alias CCSP.Chapter2.Start, as: Start2
  alias CCSP.Chapter3.Start, as: Start3

  @moduledoc """
  Convenience module to for quickly setting up and running more elaborate sections.
  """

  def run() do
    Start3.run_send_more_money()
  end
end
