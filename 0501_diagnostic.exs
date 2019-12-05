defmodule ProgramOps do
  def run(program), do: run_program_from_pos(program, 0)

  defp run_program_from_pos(program, position) do
    opcode = Enum.at(program, position)

    case do_op(opcode, position, program) do
      {updated_program, :halt} -> updated_program
      {updated_program, next_position} -> run_program_from_pos(updated_program, next_position)
    end
  end

  defp do_op(1, instruction_pointer, program) do
    {first_value, second_value} = get_both_values(program, instruction_pointer)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value + second_value),
     instruction_pointer + 4}
  end

  defp do_op(101, instruction_pointer, program) do
    first_value = Enum.at(program, instruction_pointer + 1)
    second_value = get_second_value(program, instruction_pointer)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value + second_value),
     instruction_pointer + 4}
  end

  defp do_op(1101, instruction_pointer, program) do
    first_value = Enum.at(program, instruction_pointer + 1)
    second_value = Enum.at(program, instruction_pointer + 2)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value + second_value),
     instruction_pointer + 4}
  end

  defp do_op(1001, instruction_pointer, program) do
    first_value = get_first_value(program, instruction_pointer)
    second_value = Enum.at(program, instruction_pointer + 2)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value + second_value),
     instruction_pointer + 4}
  end

  defp do_op(2, instruction_pointer, program) do
    {first_value, second_value} = get_both_values(program, instruction_pointer)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value * second_value),
     instruction_pointer + 4}
  end

  defp do_op(102, instruction_pointer, program) do
    first_value = Enum.at(program, instruction_pointer + 1)
    second_value = get_second_value(program, instruction_pointer)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value * second_value),
     instruction_pointer + 4}
  end

  defp do_op(1102, instruction_pointer, program) do
    first_value = Enum.at(program, instruction_pointer + 1)
    second_value = Enum.at(program, instruction_pointer + 2)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value * second_value),
     instruction_pointer + 4}
  end

  defp do_op(1002, instruction_pointer, program) do
    first_value = get_first_value(program, instruction_pointer)
    second_value = Enum.at(program, instruction_pointer + 2)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first_value * second_value),
     instruction_pointer + 4}
  end

  defp do_op(3, instruction_pointer, program) do
    position_to_update = Enum.at(program, instruction_pointer + 1)

    # TODO make this a legit input
    {List.replace_at(program, position_to_update, 1), instruction_pointer + 2}
  end

  defp do_op(104, instruction_pointer, program) do
    value = Enum.at(program, instruction_pointer + 1)

    IO.inspect(value)
    {program, instruction_pointer + 2}
  end

  defp do_op(4, instruction_pointer, program) do
    position_to_read = Enum.at(program, instruction_pointer + 1)
    value = Enum.at(program, position_to_read)

    IO.inspect(value)
    {program, instruction_pointer + 2}
  end

  defp do_op(99, _, program), do: {program, :halt}

  defp get_first_value(program, instruction_pointer) do
    first_position = Enum.at(program, instruction_pointer + 1)
    Enum.at(program, first_position)
  end

  defp get_second_value(program, instruction_pointer) do
    second_position = Enum.at(program, instruction_pointer + 2)
    Enum.at(program, second_position)
  end

  defp get_both_values(program, instruction_pointer) do
    first = get_first_value(program, instruction_pointer)
    second = get_second_value(program, instruction_pointer)

    {first, second}
  end
end

{:ok, program_string} = File.read("inputs/0501.txt")

program_string
|> String.trim()
|> String.split(",")
|> Enum.map(fn x ->
  {x, _} = Integer.parse(x)
  x
end)
|> ProgramOps.run()
