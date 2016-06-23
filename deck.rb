class Deck

  attr_reader :deck_array

  SUITS = [ :hearts, :diamonds, :spades, :clubs ]

  def initialize
    @deck_array = []
    create_deck
  end

  def create_deck
    SUITS.each do |suit|
      2.upto(14) do |rank|
        @deck_array << Card.new(rank, suit)
      end
    end
  end

  def pop(num_to_pop = 1)
    @deck_array.pop(num_to_pop)
  end

  def shuffle
    @deck_array.shuffle!
  end


end
