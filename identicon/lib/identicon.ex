defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  # ***** Pick Color with Pattern Matching *****
  # *We are recieving the "image" structure and also extracting the first 3 arguments
  # %Identicon.Image{hex: hex_list} = image
  # *Get the first three elements and forget the remaining elements (tail). We don't care about the last elements
  # [r, g, b | _tail] = hex_list

  # ===
  # * Same as above but better
  # %Identicon.Image{hex: [r, g, b | _tail]} = image

  # ===
  # Final result
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  # ***** Build Grid with Pattern Matching *****
  # Chunk will take a list of numbers and then it will create a list of lists
  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk_every(3)
  end

  def mirror_row(row) do
    # [2, 200, 3,]
    [a, b | _tail] = row
 
    # * Mirror
    # [2, 200, 3, 200, 2]
    row ++ [b, a]
  end
end
