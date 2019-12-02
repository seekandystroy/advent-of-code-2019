File.stream!("inputs/0101.txt")
|> Stream.map(fn x ->
  {x, _} = Integer.parse(x)
  div(x, 3) - 2
end)
|> Enum.reduce(&Kernel.+/2)
|> IO.puts()
