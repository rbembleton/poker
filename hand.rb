require_relative "card"

class Hand
  # attr_reader :hand_arr
  attr_accessor :hand_arr


  HANDS = {
    Proc.new {|hand| hand.royal_flush?} => "Royal Flush",
    Proc.new {|hand| hand.straight_flush?} => "Straight Flush",
    Proc.new {|hand| hand.four_kind?} => "Four of a Kind",
    Proc.new {|hand| hand.full_house?} => "Full House",
    Proc.new {|hand| hand.flush?} => "Flush",
    Proc.new {|hand| hand.straight?} => "Straight",
    Proc.new {|hand| hand.three_kind?} => "Three of a Kind",
    Proc.new {|hand| hand.two_pair?} => "Two Pairs",
    Proc.new {|hand| hand.two_kind?} => "Two of a Kind",
    Proc.new {|hand| hand.high_card?} => "High Card"
  }

  def initialize
    @hand_arr = []

  end

  def evaluate_hand
    eval_hands_arr.each do |prc|
      return HANDS[prc] if prc.call(self)
    end
  end

  def evaluate_hand_to_num
    eval_hands_arr.each_with_index do |prc, idx|
      return idx if prc.call(self)
    end
  end

  def discard(arr_to_discard)
    discard_idxes = arr_to_discard.sort.reverse
    discard_idxes.each {|idx| hand_arr.delete_at(idx)}
  end

  def eval_hands_arr
    HANDS.keys
  end

  def royal_flush?
    straight_flush? && lowest_card_in_hand == 10
  end

  def straight_flush?
    flush? && straight?
  end

  def four_kind?
    count_ranks.values.include?(4)
  end

  def three_kind?
    count_ranks.values.include?(3)
  end

  def two_kind?
    count_ranks.values.include?(2)
  end

  def full_house?
    three_kind? && two_kind?
  end

  def two_pair?
    count_ranks.values.count(2) == 2
  end

  def high_card?
    true
  end

  def count_ranks
    rank_hash = {}
    hand_arr.each do |card|
      if rank_hash[card.rank]
        rank_hash[card.rank] += 1
      else
        rank_hash[card.rank] = 1
      end
    end
    rank_hash
  end


  def straight?
    lowest_card = lowest_card_in_hand
    lowest_card.upto(lowest_card + 4) do |rank|
      return true if lowest_card == 2 && rank == 6 &&
        hand_arr.any? { |card| card.rank == 14 } #CHECK FOR ACE WRAP AROUND
      return false if hand_arr.none? { |card| card.rank == rank }
    end
    true
  end

  def flush?
    suit = hand_arr.first.suit
    return false unless hand_arr.all? { |card| card.suit == suit }
    true
  end

  def lowest_card_in_hand
    low = 15
    hand_arr.each do |card|
      low = card.rank if card.rank < low
    end
    low
  end

  def self.better_hand(hand1, hand2)
    #comparison is by FIRST to appear in array, so lowest value is best
    if hand1.evaluate_hand_to_num < hand2.evaluate_hand_to_num
      0
    elsif hand1.evaluate_hand_to_num > hand2.evaluate_hand_to_num
      1
    else hand1.evaluate_hand_to_num == hand2.evaluate_hand_to_num
      equal_hand_compare(hand1, hand2)
    end
  end

  def self.equal_hand_compare(hand1, hand2)
    high_1, high_2 = 0, 0

    puts hand1.hand_arr.to_s + hand1.evaluate_hand_to_num.to_s
    puts hand2.hand_arr.to_s + hand2.evaluate_hand_to_num.to_s

    if [1,4,5,9].include?(hand1.evaluate_hand_to_num) #str, str-fl, fl, hc
      hand1.hand_arr.each {|card| high_1 = card.rank if card.rank > high_1}
      hand2.hand_arr.each {|card| high_2 = card.rank if card.rank > high_2}

      # wrap around Ace case
      if (hand1.evaluate_hand_to_num == 5 || hand1.evaluate_hand_to_num == 1) &&
        (high_1 == 14 || high_2 == 14)
        p "hi"
        high_1 = 5 if hand1.hand_arr.any? {|card| card.rank == 2} && high_1 == 14
        high_2 = 5 if hand2.hand_arr.any? {|card| card.rank == 2} && high_2 == 14
      end

    elsif [2].include?(hand1.evaluate_hand_to_num) #4oak
      high_1 = hand1.count_ranks.invert[4]
      high_2 = hand2.count_ranks.invert[4]
    elsif [3, 6].include?(hand1.evaluate_hand_to_num) #fh, 3oak
      high_1 = hand1.count_ranks.invert[3]
      high_2 = hand2.count_ranks.invert[3]
    elsif [7].include?(hand1.evaluate_hand_to_num) #2p
      h1_arr = hand1.hand_arr.map {|card| card.rank}.sort
      h2_arr = hand2.hand_arr.map {|card| card.rank}.sort
      high_1 = h1_arr.count(h1_arr.last) == 2 ? h1_arr.last : h1_arr[3]
      high_2 = h2_arr.count(h2_arr.last) == 2 ? h2_arr.last : h2_arr[3]
    elsif [8].include?(hand1.evaluate_hand_to_num) #2oak
      high_1 = hand1.count_ranks.invert[2]
      high_2 = hand2.count_ranks.invert[2]
    end

    high_1 > high_2 ? 0 : 1 #checking card rank so highest value is best

  end




end

## TESTS FOR ALL HANDS

# h = Hand.new
# f = Hand.new
# check_it = h.eval_hands_arr
# h.hand_arr = [
#   Card.new(10, :hearts),
#   Card.new(11, :hearts),
#   Card.new(12, :hearts),
#   Card.new(13, :hearts),
#   Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(10, :hearts),
#   Card.new(11, :hearts),
#   Card.new(12, :hearts),
#   Card.new(13, :hearts),
#   Card.new(9, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(2, :spades),
#   Card.new(2, :hearts),
#   Card.new(2, :clubs),
#   Card.new(2, :diamonds),
#   Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(2, :spades),
#   Card.new(2, :hearts),
#   Card.new(2, :clubs),
#   Card.new(3, :hearts),
#   Card.new(3, :diamonds)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(10, :hearts),
#   Card.new(6, :hearts),
#   Card.new(12, :hearts),
#   Card.new(13, :hearts),
#   Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(2, :spades),
#   Card.new(3, :hearts),
#   Card.new(4, :clubs),
#   Card.new(5, :hearts),
#   Card.new(6, :hearts)]
#   f.hand_arr = [
#     Card.new(2, :spades),
#     Card.new(3, :hearts),
#     Card.new(4, :clubs),
#     Card.new(5, :hearts),
#     Card.new(14, :hearts)]

#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(3, :spades),
#   Card.new(3, :hearts),
#   Card.new(3, :clubs),
#   Card.new(5, :hearts),
#   Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(2, :spades),
#   Card.new(2, :hearts),
#   Card.new(3, :clubs),
#   Card.new(3, :hearts),
#   Card.new(14, :hearts)]
#   f.hand_arr = [
#     Card.new(2, :spades),
#     Card.new(2, :hearts),
#     Card.new(4, :clubs),
#     Card.new(4, :hearts),
#     Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(3, :spades),
#   Card.new(3, :hearts),
#   Card.new(2, :clubs),
#   Card.new(5, :hearts),
#   Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# h.hand_arr = [
#   Card.new(8, :spades),
#   Card.new(2, :hearts),
#   Card.new(5, :clubs),
#   Card.new(6, :hearts),
#   Card.new(14, :hearts)]
#
# p h.evaluate_hand
#
# # p h.royal_flush?
