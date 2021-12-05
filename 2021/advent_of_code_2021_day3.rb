# https://adventofcode.com/2021/day/3

def find_power_consumption(array)
  gamma = ""
  epsilon = ""
  0.upto(array.first.length - 1) do |i|
    zeros = 0
    array.each do |str|
      if str[i] == "0"
        zeros += 1
      else
        zeros -= 1
      end
    end

    if zeros > 0
      gamma << "0"
      epsilon << "1"
    else
      gamma << "1"
      epsilon << "0"
    end
  end

  puts "*** gamma = #{gamma}"
  puts "*** epsilon = #{epsilon}"

  gamma.to_i(2) * epsilon.to_i(2)
end

data = File.open("/Users/patrickgeorge/dev/personal/leetcode/advent_of_code_2021_day3_input.txt").read.split("\n").map

# puts find_power_consumption(data)

def find_oxygen_number(array)
  len = array.first.length
  0.upto(len - 1) do |i|
    zero_count = 0
    zeros = []
    ones = []
    array.each do |str|
      if str[i] == "0"
        zero_count += 1
        zeros << str
      else
        zero_count -= 1
        ones << str
      end
    end

    if zero_count > 0
      array = zeros
    else
      array = ones
    end
    return array[0].to_i(2) if array.length == 1
  end
end

o2 = find_oxygen_number(data)

def find_co2_number(array)
  len = array.first.length
  0.upto(len - 1) do |i|
    zero_count = 0
    zeros = []
    ones = []
    array.each do |str|
      if str[i] == "0"
        zero_count += 1
        zeros << str
      else
        zero_count -= 1
        ones << str
      end
    end

    if zero_count > 0
      array = ones
    else
      array = zeros
    end
    return array[0].to_i(2) if array.length == 1
  end
end

co2 = find_co2_number(data)

puts o2 * co2
