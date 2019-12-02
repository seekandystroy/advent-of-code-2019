defmodule ProgramOps do
  def run_program_from_pos(program, position) do
    op = Enum.at(program, position)

    case do_op(op, position, program) do
      {updated_program, :halt} -> updated_program
      {updated_program, next_position} -> run_program_from_pos(updated_program, next_position)
    end
  end

  defp do_op(1, current_position, program) do
    {first, second} = get_values(program, current_position)
    position_to_update = Enum.at(program, current_position + 3)

    {List.replace_at(program, position_to_update, first + second), current_position + 4}
  end

  defp do_op(2, current_position, program) do
    {first, second} = get_values(program, current_position)
    position_to_update = Enum.at(program, current_position + 3)

    {List.replace_at(program, position_to_update, first * second), current_position + 4}
  end

  defp do_op(99, _, program), do: {program, :halt}

  defp get_values(program, current_position) do
    first_position = Enum.at(program, current_position + 1)
    second_position = Enum.at(program, current_position + 2)

    first = Enum.at(program, first_position)
    second = Enum.at(program, second_position)

    {first, second}
  end
end

{:ok, program_string} = File.read("inputs/0201.txt")

program_string
|> String.trim()
|> String.split(",")
|> Enum.map(fn x ->
  {x, _} = Integer.parse(x)
  x
end)
|> List.replace_at(1, 12)
|> List.replace_at(2, 2)
|> ProgramOps.run_program_from_pos(0)
|> IO.inspect()
