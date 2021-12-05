# https://adventofcode.com/2021/day/1
# How many measurements are larger than the previous measurement?

def measurement_increases_part1(array)
  count = 0
  1.upto(array.length - 1) do |i|
    count += 1 if array[i] > array[i-1]
  end
  count
end

data = File.open("/Users/patrickgeorge/dev/personal/leetcode/advent_of_code_2021_day1_input.txt").read.split("\n").map(&:to_i)

puts measurement_increases_part1(data)

def measurement_increases_part2(array)
  count = 0
  previous_triple = array[0] + array[1] + array[2]
  3.upto(array.length - 1) do |i|
    current_triple = array[i] + array[i - 1] + array[i - 2]
    count += 1 if current_triple > previous_triple
    previous_triple = current_triple
  end
  count
end

puts measurement_increases_part2(data)
