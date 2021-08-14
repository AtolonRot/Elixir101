defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
    |> build_pixel_map()
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
    # & means reference to a function. /1 the number of arguments
    grid =
      hex
      # Deprecated: Enum.chunk(3)
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      # Creates a tuple for every element {number, INDEX}
      |> Enum.with_index(0)

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # [2, 200, 3,]
    [a, b | _tail] = row

    # * Mirror
    # [2, 200, 3, 200, 2]
    row ++ [b, a]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        # In Java: 20 % 9 = 2
        # Return true/false whether is odd or not
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end
end
