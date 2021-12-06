# def simulate_fish(ages, days)
#
#   school = ages.map do |age|
#     Fish.new(age)
#   end
#
#   days.times do |day|
#     new_fishes = []
#     school.each do |fish|
#       new_fish = fish.age!
#       new_fishes << new_fish if new_fish
#     end
#     school += new_fishes
#   end
#   school
# end
#
# class Fish
#   SPAWN_AGE = 8
#   RESET_AGE = 6
#   def initialize(age)
#     @age = age.to_i
#   end
#
#   def age!
#     @age -= 1
#
#     if @age < 0
#       @age = RESET_AGE
#       Fish.spawn!
#     else
#       nil
#     end
#   end
#
#   def to_s
#     "age = #{@age}"
#   end
#
#   def self.spawn!
#     Fish.new(SPAWN_AGE)
#   end
# end

def simulate_fish(ages, days)
  hash = Hash.new(0)
  ages.each do |age|
    hash[age] += 1
  end

  days.times do
    prev = hash[8]
    7.downto(-1) do |day|
      tmp = hash[day]
      hash[day] = prev
      prev = tmp
    end
    hash[8] = hash[-1]
    hash[6] += hash[-1]
    hash[-1] = 0
  end

  tmp = hash.values
  tmp.sum
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day6_input.txt").read.split(",").map(&:to_i)

pp simulate_fish(data, 256)

def test_simulate_fish
  data = [3,4,3,1,2]
  result = [6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8]
  if simulate_fish(data, 18) == result.length
    puts "PASS"
  else
    puts "FAIL"
  end

  if simulate_fish(data, 80) == 5934
    puts "PASS"
  else
    puts "FAIL"
  end

  if simulate_fish(data, 256) == 26984457539
    puts "PASS"
  else
    puts "FAIL"
  end
end

test_simulate_fish
