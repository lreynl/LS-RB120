require 'io/console'

module TerminalUtilities
  def prompt(text)
    print "> #{text}"
  end

  def clear
    system 'clear' || 'cls'
  end
end

class TwentyOneGame
  include TerminalUtilities

  WINS_FOR_MATCH = 5
  MAX_SCORE = 21

  def initialize
    @deck = nil
    @player = nil
    @dealer = nil
  end

  def play
    title
    loop do
      reset_game
      round_loop
      break unless match_winner?
      final_match_score
      break unless @dealer.continue?(:match)
    end
  end

  private

  def reset_game
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def shuffle_cards_reset_score
    @deck.shuffle!
    @player.hand.reset
    @dealer.hand.reset
  end

  def match_winner?
    @player.points == WINS_FOR_MATCH ||
      @dealer.points == WINS_FOR_MATCH
  end

  def display_match_score
    prompt("Match total: Player #{@player.points}, " \
           "Dealer #{@dealer.points}\n\n")
  end

  def final_match_score
    prompt("Final match score: Player, #{@player.points}, " \
           "Dealer #{@dealer.points}\n\n")
  end

  def deal
    @player.deal(@deck)
    @dealer.deal(@deck)
    display_cards
  end

  def play_cards
    @player.turn(@deck, @dealer)
    @dealer.turn(@deck, @player)
    display_all_cards
  end

  def analyze_results
    result = round_result
    @dealer.check_perfect_score(@player)
    inc_points(result)
    @dealer.results_message(result)
    @dealer.display_round_score(@player)
  end

  def round_loop
    until match_winner?
      deal
      play_cards
      analyze_results
      break if match_winner?
      display_match_score
      break unless @dealer.continue?(:round)
      shuffle_cards_reset_score
    end
  end

  def title
    clear
    prompt("♤ ♡ ♧ ♢  21 Game ♤ ♡ ♧ ♢ \n\n")
    prompt("First to #{WINS_FOR_MATCH} wins\n\n")
    prompt('Press any key to start')
    STDIN.getch
    clear
  end

  def display_cards
    clear
    @dealer.display_cards
    @player.display_cards
  end

  def display_all_cards
    clear
    @dealer.display_cards_plus_face_down
    @player.display_cards
  end

  def round_result
    if @player.hand.score > MAX_SCORE
      :p_bust
    elsif @dealer.hand.score > MAX_SCORE
      :d_bust
    elsif @dealer.hand.score > @player.hand.score
      :dealer
    elsif @dealer.hand.score < @player.hand.score
      :player
    else
      :tie
    end
  end

  def inc_points(winner)
    @player.increment_points if winner == :player || winner == :d_bust
    @dealer.increment_points if winner == :dealer || winner == :p_bust
  end
end

class Deck
  VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
             '8' => 8, '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10,
             'K' => 10 }.freeze

  attr_reader :cards

  def initialize
    shuffle!
  end

  def shuffle!
    deck = []
    suits = ['♤', '♡', '♧', '♢']
    val = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits.each do |suit|
      val.each do |value|
        deck.push(value + suit)
      end
    end
    @cards = deck
  end
end

class Hand
  attr_accessor :cards, :score, :ace_eleven

  def initialize
    reset
  end

  def reset
    @cards = []
    @score = 0
    @ace_eleven = false
  end

  def score_ace!
    if @score <= 10
      @score += 11
      @ace_eleven = true
    else
      @score += 1
    end
  end

  def rescore_ace!
    return unless @ace_eleven && @score > TwentyOneGame::MAX_SCORE
    @score -= 10
    @ace_eleven = false
  end

  def update_score!(card)
    if card.chop == 'A'
      score_ace!
    else
      @score += Deck::VALUES[card.chop]
    end
    rescore_ace!
  end
end

class Participant
  include TerminalUtilities

  HAND_SIZE = 2
  VALID_HIT_STAY = ['h', 'hit', 's', 'stay']
  VALID_YES_NO = ['y', 'yes', 'n', 'no']

  attr_reader :hand, :points

  def initialize
    @hand = Hand.new
    @points = 0
  end

  def deal(deck, size = HAND_SIZE)
    size.times { hit_me!(deck) }
  end

  def draw!(deck)
    card = deck.cards.sample
    deck.cards.delete(card)
    card
  end

  def hit?
    response = user_hit_stay
    response.downcase == 'hit' || response.downcase == 'h'
  end

  def hit_me!(deck)
    card = draw!(deck)
    @hand.cards << card
    hand.update_score!(card)
  end

  def user_hit_stay
    hit_stay = ''
    loop do
      prompt("Hit or stay (h/s)? ")
      hit_stay = gets.chomp.downcase
      break if VALID_HIT_STAY.include?(hit_stay)
      next if hit_stay.empty?
      prompt("Not a valid choice!\n")
    end
    hit_stay
  end

  def score
    hand.score
  end

  def bust?
    score >= TwentyOneGame::MAX_SCORE
  end

  def check_perfect_score(player)
    if player.hand.score == TwentyOneGame::MAX_SCORE ||
       hand.score == TwentyOneGame::MAX_SCORE
      prompt("Perfect score!\n")
    end
  end

  def increment_points
    @points += 1
  end

  def results_message(winner)
    case winner
    when :p_bust
      prompt("You went bust! Dealer wins!\n")
    when :d_bust
      prompt("Dealer went bust! You win!\n")
    when :dealer
      prompt("Dealer wins!\n")
    when :player
      prompt("You win!\n")
    when :tie
      prompt("It was a tie!\n")
    end
  end

  def display_round_score(player)
    prompt("Your score was #{player.hand.score}. " \
           "Dealer score was #{hand.score}.\n\n")
  end

  def user_yes_no(option)
    choice = ''
    loop do
      prompt('Keep playing? (y/n) ') if option == :round
      prompt('Rematch? (y/n) ')      if option == :match
      choice = gets.chomp.downcase
      break unless choice.empty? || !VALID_YES_NO.include?(choice)
      prompt("Enter (y/n)\n")
    end
    choice
  end

  def continue?(option = :round)
    response = user_yes_no(option)
    response == 'y' || response == 'yes'
  end
end

class Player < Participant
  include TerminalUtilities

  def turn(deck, dealer)
    until bust?
      hit? ? hit_me!(deck) : break
      clear
      dealer.display_cards
      display_cards
    end
  end

  def display_cards
    hand.cards.each_with_index do |card, index|
      prompt("Player: #{card} ") if index.zero?
      print card + ' ' unless index.zero?
    end
    puts "\n\n"
  end
end

class Dealer < Participant
  DEALER_STAY = 17

  def dealers_turn?(player)
    !bust? && !player.bust? && hand.score <= DEALER_STAY
  end

  def display_cards
    hand.cards.each_with_index do |card, index|
      prompt('Dealer: Face-down card, ') if index.zero?
      print card + ' ' unless index.zero?
    end
    puts "\n\n"
  end

  def display_cards_plus_face_down
    hand.cards.each_with_index do |card, index|
      prompt("#{card} ") if index.zero?
      print card + ' ' unless index.zero?
    end
    puts "\n\n"
  end

  def turn(deck, player)
    while dealers_turn?(player)
      hit_me!(deck)
    end
  end
end

TwentyOneGame.new.play
