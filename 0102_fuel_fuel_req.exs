defmodule FuelReq do
  def fuel_calc(x) do
    fuel_needed = div(x, 3) - 2

    fuel_needed + further_fuel_calc(fuel_needed)
  end

  defp further_fuel_calc(x) when x >= 9, do: fuel_calc(x)
  defp further_fuel_calc(_), do: 0
end

File.stream!("inputs/0102.txt")
|> Stream.map(fn x ->
  {x, _} = Integer.parse(x)
  x
end)
|> Stream.map(&FuelReq.fuel_calc/1)
|> Enum.reduce(&Kernel.+/2)
|> IO.puts()
