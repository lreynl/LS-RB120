class Shelter
  def initialize
    @owner_list = {}
  end

  def adopt(owner_obj, pet_obj)
    if !@owner_list.keys.include?(owner_obj)
      @owner_list[owner_obj] = []
    end
    owner_obj.adopt
    @owner_list[owner_obj] << pet_obj
  end

  def print_adoptions
    if @owner_list.empty?
      puts "There have been no adoptions."
      return
    end
    @owner_list.each_pair do |owner, pet_list|
      puts "#{owner.name} has adopted the following pets:"
      pet_list.each { |pet| puts "a #{pet.species} named #{pet.name}" }
      puts ''
    end
  end
  
  private

  attr_accessor :owner_list
end

class Owner
  attr_reader :name
 
  def initialize(name)
    @name = name
    @pets_owned = 0
  end

  def number_of_pets
    @pets_owned
  end

  def adopt
    @pets_owned += 1
  end
end

class Pet
  attr_reader :name, :species

  def initialize(species, name)
    @species = species
    @name = name
  end

end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."