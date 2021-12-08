def find_shortest_distance_part1(array)
  min_distance = 2 ** 32 - 1

  array.each_with_index do |_, i|
    current_min = 0
    array.each_with_index do |_, j|
      current_min += (array[i] - array[j]).abs
    end
    min_distance = [min_distance, current_min].min
  end
  min_distance
end

def find_shortest_distance_part2(array)
  min_distance = 2 ** 32 - 1
  array.sort!
  (array[0]..array[-1]).each do |pos|
    current_min = 0
    array.each do |crab|
      current_min += triangle_number((pos - crab).abs)
    end
    min_distance = [min_distance, current_min].min
  end
  puts "*** min_distance = #{min_distance}"
  min_distance
end

def triangle_number(n)
  (n * (n + 1)) / 2
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day7_input.txt").read.split(",").map(&:to_i)

pp find_shortest_distance_part1(data)

pp find_shortest_distance_part2(data)

def test_find_shortest_distance_part1
  data = [16,1,2,0,4,2,7,1,2,14]

  pp find_shortest_distance_part1(data) == 37
end

test_find_shortest_distance_part1

# =======


def test_find_shortest_distance_part2
  data = [16,1,2,0,4,2,7,1,2,14]

  pp find_shortest_distance_part2(data) == 168
end

test_find_shortest_distance_part2
