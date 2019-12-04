defmodule WireMapper do
  def add_wire(vector, {{start_x, start_y} = start_point, horizontals, verticals, lines) do
    {direction, value_string} = String.split_at(vector, 1)
    {value, _} = Integer.parse(value_string)

    case {direction, value} do
      {"R", x} ->
        end_point = {start_x + x, start_y}
        line = {start_point, end_point}
        {end_point, [line | horizontals], verticals, [line | lines]}

      {"L", x} ->
        end_point = {start_x - x, start_y}
        line = {end_point, start_point}
        {end_point, [line | horizontals], verticals, [line | lines]}

      {"U", y} ->
        end_point = {start_x, start_y + y}
        line = {start_point, end_point}
        {end_point, horizontals, [line | verticals], [line | lines]}

      {"D", y} ->
        end_point = {start_x, start_y - y}
        line = {end_point, start_point}
        {end_point, horizontals, [line | verticals], [line | lines]}
    end
  end
end

defmodule PointOperations do
  def intersection({{hx1, hy}, {hx2, hy}}, {{vx, vy1}, {vx, vy2}}) do
    if hx1 < vx and hx2 > vx and vy1 < hy and vy2 > hy do
      {vx, hy}
    else
      nil
    end
  end

  def manhattan_distance_to_origin({x, y}) do
    abs(x) + abs(y)
  end
end

[{_, first_horizontals, first_verticals, first_lines}, {_, second_horizontals, second_verticals, second_lines}] =
  File.stream!("inputs/0302.txt")
  |> Enum.map(fn line ->
    String.trim(line)
    |> String.split(",")
    |> Enum.reduce({{0, 0}, [], [], []}, &WireMapper.add_wire/2)
  end)

first_intersections =
  Enum.flat_map(first_horizontals, fn h_line ->
    Enum.map(second_verticals, fn v_line ->
      PointOperations.intersection(h_line, v_line)
    end)
    |> Enum.reject(&is_nil/1)
  end)

second_intersections =
  Enum.flat_map(second_horizontals, fn h_line ->
    Enum.map(first_verticals, fn v_line ->
      PointOperations.intersection(h_line, v_line)
    end)
    |> Enum.reject(&is_nil/1)
  end)

(first_intersections ++ second_intersections)
|> Enum.map(&PointOperations.manhattan_distance_to_origin/1)
|> Enum.min()
|> IO.inspect()
