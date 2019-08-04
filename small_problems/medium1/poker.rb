class Card
  attr_reader :rank, :suit, :cards

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }
  
  def <=>(other_card)
    other_rank = other_card.rank
    rank_copy = rank
    unless rank.class == Integer
      rank_copy = VALUES[rank]
    end
    unless other_rank.class == Integer
      other_rank = VALUES[other_rank]
    end
    if rank_copy < other_rank
      -1
    elsif rank_copy > other_rank
      1
    else
      compare_suits(other_card)
    end
  end

  def compare_suits(other_card)
    if suit == other_card.suit
      0
    elsif suit == 'Spades'
      1
    elsif other_card.suit == 'Spades'
      -1
    elsif suit == 'Hearts'
      1
    elsif other_card.suit == 'Hearts'
      -1
    elsif suit == 'Clubs'
      1
    elsif other_card.suit == 'Clubs'
      -1
    end
  end
=begin
  def ==(other_card)
    self.rank == other_card.rank &&
      self.suit == other_card.suit
  end
=end
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    @cards = []
    init_cards
  end

  def draw
    if @cards.empty?
      init_cards
    end
    card = @cards.sample
    @cards.delete(card)
    card
  end

  private

  def init_cards
    RANKS.each do |rank|
      SUITS.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
  end
end

class PokerHand
  def initialize(deck)
    @deck = deck
    @hand = []
    deal
    @hand_ranks = init_hand_ranks
  end

  def deal
    5.times { @hand << @deck.draw }
  end

  def print
    @hand.each { |card| puts "#{card.rank} of #{card.suit}" }
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def init_hand_ranks
    ranks = []
    @hand.each do |card| 
      if card.rank.class == Integer
        ranks << card.rank
      else
        ranks << Card::VALUES[card.rank]
      end
    end
    @hand_ranks = ranks
  end

  def royal_flush?
    straight_flush? && @hand_ranks.include?(14)
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    hash_cards.values.count(4) == 1
  end

  def full_house?
    card_count = hash_cards
    card_count.values.count(3) == 1 && card_count.values.count(2) == 1
  end

  def flush?
    counter = 1
    until counter == @hand.length - 1
      return false if @hand[0].suit != @hand[counter].suit
      counter += 1
    end
    true
  end

  def straight?
    low = @hand_ranks.min
    high = @hand_ranks.max
    (low..high).to_a.each do |value|
      return false unless @hand_ranks.include?(value)
    end
  end

  def three_of_a_kind?
    card_count = hash_cards
    card_count.values.count(3) == 1 && card_count.values.count(1) == 2
  end

  def two_pair?
    card_count = hash_cards
    card_count.values.count(2) == 2
  end

  def pair?
    card_count = hash_cards
    card_count.values.count(2) == 1 && card_count.values.count(1) == 3
  end

  def hash_cards
    card_count = {}
    @hand.each do |card|
      card_count[card.rank] ||= 0
      card_count[card.rank] += 1
    end
    #p card_count
    card_count
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new('Jack', 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new('Jack', 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'