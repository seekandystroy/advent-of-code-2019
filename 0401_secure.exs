defmodule SequenceOps do
end

Enum.filter(
  165_432..707_912,
  fn number ->
    {has_double, is_monotonic_inc, _} =
      Integer.to_charlist(number)
      |> Enum.reduce_while({false, true, 0}, fn number,
                                                {has_double, _is_monotonic_inc, previous} ->
        has_double = has_double || number == previous

        if number >= previous do
          {:cont, {has_double, true, number}}
        else
          {:halt, {has_double, false, number}}
        end
      end)

    has_double and is_monotonic_inc
  end
)
|> length()
|> IO.inspect()
