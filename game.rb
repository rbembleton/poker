require_relative "card"
require_relative "deck"
require_relative "hand"
require_relative "player"


class Game
  attr_reader :deck, :players, :current_player

  def initialize(*players)
    @players = []
    players.each do |player|
      @players << Player.new(player)
    end

    @deck = Deck.new.shuffle
    @current_player = 0

  end

  def run
    deal_cards_start
    players.length.times {round_one}
    # bidding_one
    players.length.times {card_exchange}
    players.length.times {round_two}
    # bidding_two
    display_winner

  end

  def round_one
    display_stats_and_hand
    puts "Press Enter or Space to move to next player"
    gets
    switch_player
  end

  def card_exchange
    display_stats_and_hand
    puts "Which cards (positions) would you like to exchange? Ex: 0,2,3"
    cards_to_exchange = interpret_input(gets.chomp)
    exchange_cards(cards_to_exchange)
    display_stats_and_hand
    puts "Press Enter or Space to move to next player"
    gets
    switch_player
  end

  def round_two
    display_stats_and_hand
    puts "Press Enter or Space to move to next player"
    gets
    switch_player
  end

  def display_stats_and_hand
    system("clear")
    puts "Current Player: #{players[current_player]}"
    puts "Best Hand: #{best_hand}\n\n"
    players[current_player].display_hand
    puts
  end

  def display_winner
    if players.length == 1
      current_best = 0
    else
      current_best = Hand.better_hand(players[0].hand, players[1].hand)
    end

    2.upto(players.length - 1) do |idx|
      new_best = Hand.better_hand(players[current_best].hand, players[idx].hand)
      current_best = new_best == 0 ? current_best : idx
    end


    system("clear")
        # p players[current_player].hand
    @current_player = current_best
    puts "#{players[current_player].to_s.upcase} WINS!"
    puts "With a hand of: #{best_hand}\n\n"
    players[current_player].display_hand
    puts

  end

  def best_hand
    players[current_player].hand.evaluate_hand
  end

  def deal_cards_start
    players.each do |player|
      player.hand.hand_arr += deck.pop(5)
    end
  end

  def exchange_cards(arr_to_exchange)
    players[current_player].hand.discard(arr_to_exchange)
    players[current_player].hand.hand_arr += deck.pop(arr_to_exchange.length)
  end


  def switch_player
    @current_player += 1
    @current_player = 0 if current_player == players.length
  end

  def interpret_input(string)
    arr = string.split(',')
    arr.map! {|el| el.to_i}
  end



end


if __FILE__ == $PROGRAM_NAME

  mygame = Game.new("RB", "Jon", "Kaelyn", "James")
  mygame.run


end
