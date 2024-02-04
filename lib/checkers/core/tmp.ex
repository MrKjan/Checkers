defmodule Checkers.Core.Tmp do
  defmacro foo(:a), do: true
  defmacro foo(_), do: false

  # defmacro foo(param) do
  #   quote do
  #     param == :a
  #   end
  # end

  def bar(_baz) do
    cond do
      foo(baz) -> true
      true -> false
    end
  end
end
