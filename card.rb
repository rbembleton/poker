class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end


  def to_s
    ret_str = ""
    rank > 10 ? ret_str += rank_conv[rank] : ret_str += rank.to_s
    ret_str += " of #{suit.capitalize}"
  end

  def rank_conv
    {
      11 => "Jack",
      12 => "Queen",
      13 => "King",
      14 => "Ace"
    }
  end

end
