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

  def ==(other_card)
    self.rank == other_card.rank &&
      self.suit == other_card.suit
  end

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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.