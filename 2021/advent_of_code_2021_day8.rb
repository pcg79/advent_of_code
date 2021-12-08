def count_digits_with_unique_makeups(lines)
  count = 0

  lines.each do |line|
    input, output = line.split(" | ")
    output.split(" ").each do |letter|
      count += 1 if [2, 3, 4, 7].include?(letter.length)
    end
  end
  count
end

# length -> number
# 2 -> 1
# 3 -> 7
# 4 -> 4
# 5 -> 2, 3, 5
# 6 -> 0, 6, 9
# 7 -> 8
def figure_out_segment_assignments(lines)
  total = 0
  lines.each do |line|
    input, output = line.split(" | ")
    input = input.split(" ")
    output = output.split(" ")

    hash = Hash.new { |h, k| h[k] = Array.new }
    input.each do |number|
      number = number.chars.sort.join
      case number.length
      when 2
        hash[1] = number
      when 3
        hash[7] = number
      when 4
        hash[4] = number
      when 5
        hash[2] << number
        hash[3] << number
        hash[5] << number
      when 6
        hash[0] << number
        hash[6] << number
        hash[9] << number
      when 7
        hash[8] = number
      end
    end

    # At this point we know 1, 4, 7, 8.  Time to figure out the rest.

    # check 6-length numbers (0, 6, 9)
    sixes_temp = hash[0]
    sixes_temp.each do |num|
      # check intersection with number 1
      inter = intersection(hash[1], num)
      if inter.length == 1 # num == 6
        hash[6] = num
      else # Either 0 or 9
        # check intersection with number 4
        inter = intersection(hash[4], num)
        if inter.length == 3   # num == 0
          hash[0] = num
        else # num == 9
          hash[9] = num
        end
      end
    end

    # check 5-length numbers (2, 3, 5)
    fives_temp = hash[2]
    fives_temp.each do |num|
      # check difference with number 9
      diff = num.delete(hash[9])
      if diff.length == 1 # num = 2
        hash[2] = num
      else # Either 3 or 5
        # check difference with number 6
        diff = num.delete(hash[6])
        if diff.length == 1 # num = 3
          hash[3] = num
        else # num = 5
          hash[5] = num
        end
      end
    end

    lookup = hash.invert
    output_num = 0
    output.each do |number|
      number = number.chars.sort.join
      output_num = (output_num * 10) + lookup[number]
    end

    total += output_num
  end
  total
end

def intersection(str1, str2)
  str1.split("") & str2.split("")
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day8_input.txt").read.split("\n")

# pp count_digits_with_unique_makeups(data)


def test_count_digits_with_unique_makeups
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day8_test_input.txt").read.split("\n")

  pp count_digits_with_unique_makeups(data) == 26
end

# test_count_digits_with_unique_makeups

pp figure_out_segment_assignments(data)

def test_figure_out_segment_assignments
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day8_test_input.txt").read.split("\n")

  pp figure_out_segment_assignments(data) == 61229
end
test_figure_out_segment_assignments
