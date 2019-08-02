require 'io/console'

module Prompt
  def prompt(text)
    print "> #{text}"
  end
end

class TwentyOneGame
  include Prompt

  WINS_FOR_MATCH = 5
  MAX_SCORE = 21

  def initialize
    @match_score = init_match_score
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end
  
  def clear
    system 'clear' || 'cls'
  end

  def match_winner?
    @match_score[:player] == WINS_FOR_MATCH ||
      @match_score[:dealer] == WINS_FOR_MATCH
  end

  def play
    title
    #until match_winner?
      @player.deal(@deck)
      @dealer.deal(@deck)
      display_cards
      until @player.bust?
        @player.hit? ? @player.hit_me!(@deck) : break
        display_cards
      end
      while @dealer.dealers_turn?(@player)
        @dealer.hit_me!(@deck)
      end
      display_cards
      result = round_score
      p result
    #end    
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
    @dealer.hand.cards.each_with_index do |card, index|
      prompt('Dealer: Face-down card, ') if index == 0
      print card + ' ' unless index == 0
    end
    puts "\n\n"
    @player.hand.cards.each_with_index do |card, index|
      prompt("Player: #{card} ") if index == 0
      print card + ' ' unless index == 0
    end
    puts "\n\n"
  end
  
  def init_match_score
    @match_score = { player: 0, dealer: 0 }
  end
  
  def round_score
    if @player.hand.score > MAX_SCORE
      :p_bust
    elsif @dealer.hand.score > MAX_SCORE
      :d_bust
    elsif @dealer.hand.score > @player.hand.score
      :dealer
    elsif @dealer.hand.score < @player.hand.score
      :player
    elsif @player.hand.score == @dealer.hand.score
      :tie
    end
  end
end

class Deck
  VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8,
           '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10 }.freeze

  attr_reader :cards
  
  def initialize
    @cards = shuffle
  end
  
  def shuffle
    deck = []
    suits = ['♤', '♡', '♧', '♢']
    val = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits.each do |suit|
      val.each do |value|
        deck.push(value + suit)
      end
    end
    deck
  end
end

class Hand
  attr_accessor :cards, :score, :ace_eleven

  def initialize
    @cards = []
    @score = 0
    @ace_eleven = false
    
  end
end 

class Participant
  include Prompt
  
  HAND_SIZE = 2
  VALID_HIT_STAY = ['h', 'hit', 's', 'stay']

  attr_reader :hand
  
  def initialize
    @hand = Hand.new
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
    self.hand.cards << card
    p card
    update_score!(self.hand, card)
  end
  
  def user_hit_stay
    hit_stay = ''
    loop do
      prompt("Hit or stay (h/s)? ")
      hit_stay = gets.chomp
      if VALID_HIT_STAY.include?(hit_stay)
        break
      else
        prompt("Not a valid choice!\n")
        next
      end
    end
    hit_stay
  end

  def score_ace!(hand)
    if hand.score <= 10
      hand.score += 11
      hand.ace_eleven = true
    else
      hand.score += 1
    end
  end
  
  def rescore_ace!(hand)
    if hand.ace_eleven && hand.score > TwentyOneGame::MAX_SCORE
      hand.score -= 10
      hand.ace_eleven = false
    end
  end
  
  def update_score!(hand, card)
    if card.chop == 'A'
      score_ace!(hand)
    else
      hand.score += Deck::VALUES[card.chop]
    end
    rescore_ace!(hand)
  end

  def score
    hand.score
  end

  def bust?
    score >= TwentyOneGame::MAX_SCORE
  end
end

class Player < Participant

end

class Dealer < Participant
  DEALER_STAY = 17
  
  def dealers_turn?(player)
    !bust? && !player.bust? && hand.score <= DEALER_STAY
  end
end

TwentyOneGame.new.play