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

cards = [Card.new(2, 'Hearts'),
         Card.new(10, 'Diamonds'),
         Card.new('Ace', 'Clubs')]
puts cards
puts cards.min == Card.new(2, 'Hearts')
puts cards.max == Card.new('Ace', 'Clubs')

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
         Card.new(4, 'Diamonds'),
         Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
         Card.new('Jack', 'Diamonds'),
         Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'

cards = [Card.new(8, 'Diamonds'),
         Card.new(8, 'Clubs'),
         Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8

cards = [Card.new(5, 'Spades'),
         Card.new(5, 'Diamonds'),
         Card.new(5, 'Clubs'),
         Card.new(5, 'Hearts')]

puts cards.max == Card.new(5, 'Spades')
puts cards.min == Card.new(5, 'Hearts')
puts cards.min == Card.new(5, 'Diamonds')

cards = [Card.new(5, 'Diamonds'),
         Card.new(6, 'Diamonds'),
         Card.new(7, 'Diamonds'),
         Card.new(8, 'Diamonds')]

puts cards.max == Card.new(8, 'Diamonds')
puts cards.min == Card.new(5, 'Diamonds')

