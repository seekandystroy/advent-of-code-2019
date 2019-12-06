defmodule OrbitFirstSearch do
  def get_total_orbits(map, object, previous_orbits \\ 0) do
    children = Map.get(map, object, [])

    previous_orbits +
      Enum.reduce(children, 0, fn child, acc ->
        acc + get_total_orbits(map, child, previous_orbits + 1)
      end)
  end
end

{orbits_map, parents_map} =
  File.stream!("inputs/0601.txt")
  |> Enum.reduce({%{}, %{}}, fn orbit, {orbits_map, parents_map} ->
    [center, orbiting] =
      String.trim(orbit)
      |> String.split(")")

    new_orbits_map =
      Map.update(orbits_map, center, [orbiting], fn children ->
        [orbiting | children]
      end)

    new_parents_map =
      Map.update(parents_map, orbiting, 1, fn parents_count ->
        parents_count + 1
      end)
      |> Map.put_new(center, 0)

    {new_orbits_map, new_parents_map}
  end)

map_size(orbits_map)
|> IO.inspect()

map_size(parents_map)
|> IO.inspect()

[start_object] =
  Enum.filter(parents_map, fn {_, v} -> v == 0 end)
  |> Enum.map(fn {k, _} -> k end)

OrbitFirstSearch.get_total_orbits(orbits_map, start_object)
|> IO.inspect()
