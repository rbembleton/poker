class Player
  attr_reader :name
  attr_accessor :hand

  def initialize(name)
    @name = name
    @hand = Hand.new
  end


  def display_hand
    hand.hand_arr.each_with_index do |card, idx|
      puts "#{idx}. #{card.to_s}"
    end
  end

  def to_s
    @name.to_s
  end



end
