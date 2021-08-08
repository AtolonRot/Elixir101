defmodule Cards do
  def create_deck do
    values = ["1", "2", "3"]
    suits = ["Clubs", "Hearts", "Diamonds"]

    # cards =
    #   for value <- values do
    #     for suit <- suits do
    #       "#{value} of #{suit}"
    #     end
    #   end
    # List.flatten(cards)


    # ***
    # This approach is like the above
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  # *** Pipe Operator
  def create_deck(hand_size) do
    # deck = Cards.create_deck()
    # deck = Cards.shuffle(deck)
    # hand = Cards.deal(deck, hand_size)

    # The result of each method is automatically sent to the next
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, hand) do
    Enum.member?(deck, hand)
  end

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    # {status, binary} = File.read(filename)

    # case status do
    #   :ok -> :erlang.binary_to_term(binary)
    #   :error -> "That file doesn't exist"
    # end


    # ***
    # Pattern Matching in case Statements
    # This approach is like the above
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file doesn't exist"
    end
  end
end
