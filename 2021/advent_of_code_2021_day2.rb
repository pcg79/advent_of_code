def find_position(array)
  forward = 0
  depth = 0
  aim = 0
  array.each do |command|
    direction, distance = command.split(" ")
    distance = distance.to_i
    case direction
    when "forward"
      forward += distance
      depth += aim * distance
    when "down"
      aim += distance
    when "up"
      aim -= distance
    end
  end

  puts "*** forward = #{forward}"
  puts "*** depth = #{depth}"
  forward * depth
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day2_input.txt").read.split("\n").map

puts find_position(data)
