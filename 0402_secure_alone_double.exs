defmodule SequenceOps do
end

Enum.filter(
  165_432..707_912,
  fn number ->
    {has_double, is_monotonic_inc, _, _} =
      Integer.to_charlist(number)
      |> Enum.reduce_while({false, true, 0, 0}, fn number,
                                                   {has_double, _is_monotonic_inc, previous,
                                                    current_double_digit} ->
        new_has_double =
          number != current_double_digit and
            (has_double ||
               number == previous)

        current_double_digit =
          if !has_double and number == previous do
            number
          else
            current_double_digit
          end

        if number >= previous do
          {:cont, {new_has_double, true, number, current_double_digit}}
        else
          {:halt, {new_has_double, false, number, current_double_digit}}
        end
      end)

    has_double and is_monotonic_inc
  end
)
|> length()
|> IO.inspect()
