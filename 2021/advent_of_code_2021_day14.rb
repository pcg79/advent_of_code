def process_data(data, steps)
  template, rules = split_data(data)
  # output = hashify(template)
  steps.times do |i|
    puts "*** i = #{i}"
    output = process_step(output, rules)
  end
  output
end

# def hashify(string)
#   hash = Hash.new(0)
#
#   0.upto(string.length - 2) do |i|
#     pair = "#{string[i]}#{string[i+1]}"
#     hash[pair] += 1
#   end
#   hash
# end

def quantity_score(input)
  hash = Hash.new(0)
  input.each_char do |char|
    hash[char] += 1
  end

  max = 0
  min = 2 ** 32 - 1
  hash.each_pair do |char, count|
    min = [min, count].min
    max = [count, max].max
  end

  max - min
end

def split_data(data)
  template = data[0]
  rules = {}
  2.upto(data.length - 1) do |i|
    pair, insertion = data[i].split(" -> ")
    rules[pair] = insertion
  end
  return template, rules
end

def process_step(string, rules)
  output = ""
  0.upto(string.length - 2) do |i|
    pair = "#{string[i]}#{string[i+1]}"
    output << string[i] << rules[pair]
  end
  output << string[-1]
  output
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day14_input.txt").read.split("\n")

# pp quantity_score(process_data(data, 10))

# ------- TESTS --------

def test_process_data
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day14_test_input.txt").read.split("\n")

  pp process_data(data, 1) == "NCNBCHB"
  # pp process_data(data, 2) == "NBCCNBBBCBHCB"
  # pp process_data(data, 3) == "NBBBCNCCNBBNBNBBCHBHHBCHB"
  # pp process_data(data, 4) == "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"

  pp quantity_score(process_data(data, 10)) == 1588

  # pp quantity_score(process_data(data, 40)) == 2188189693529
end

test_process_data
