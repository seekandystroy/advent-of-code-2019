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
    {first, second} = get_values(program, instruction_pointer)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first + second), instruction_pointer + 4}
  end

  defp do_op(2, instruction_pointer, program) do
    {first, second} = get_values(program, instruction_pointer)
    position_to_update = Enum.at(program, instruction_pointer + 3)

    {List.replace_at(program, position_to_update, first * second), instruction_pointer + 4}
  end

  defp do_op(99, _, program), do: {program, :halt}

  defp get_values(program, instruction_pointer) do
    first_position = Enum.at(program, instruction_pointer + 1)
    second_position = Enum.at(program, instruction_pointer + 2)

    first = Enum.at(program, first_position)
    second = Enum.at(program, second_position)

    {first, second}
  end
end

{:ok, program_string} = File.read("inputs/0202.txt")

program =
  program_string
  |> String.trim()
  |> String.split(",")
  |> Enum.map(fn x ->
    {x, _} = Integer.parse(x)
    x
  end)

Enum.each(0..99, fn noun ->
  Enum.each(0..99, fn verb ->
    output =
      program
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)
      |> ProgramOps.run()
      |> Enum.at(0)

    if output == 19_690_720 do
      IO.inspect({noun, verb, 100 * noun + verb})
    end
  end)
end)
