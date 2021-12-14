def process_data(data, steps)
  template, rules = split_data(data)
  start_char, end_char = template[0], template[-1]
  output_hash = hashify(template)
  letter_count = starting_count(template)
  steps.times do |i|
    output_hash, letter_count = process_step(output_hash, letter_count, rules)
  end
  letter_count
end

def hashify(string)
  hash = Hash.new(0)

  0.upto(string.length - 2) do |i|
    pair = "#{string[i]}#{string[i+1]}"
    hash[pair] += 1
  end
  hash
end

def starting_count(string)
  hash = Hash.new(0)
  string.each_char do |char|
    hash[char] += 1
  end
  hash
end

def quantity_score(letter_count)
  max = 0
  min = nil
  letter_count.values.each do |count|
    min = count unless min
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

{
  "NN" => 1,
  "NC" => 1,
  "CB" => 1,
}

{
  "N" => 2,
  "C" => 1,
  "B" => 1,
}

def process_step(pair_hash, letter_count, rules)
  new_pair_hash = Hash.new(0)
  pair_hash.each_pair do |pair, count|
    new_char = rules[pair]
    new_pair_one = "#{pair[0]}#{new_char}"
    new_pair_two = "#{new_char}#{pair[1]}"
    letter_count[new_char] += count
    new_pair_hash[new_pair_one] += count
    new_pair_hash[new_pair_two] += count
  end
  return new_pair_hash, letter_count
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day14_input.txt").read.split("\n")

pp quantity_score(process_data(data, 10))

pp quantity_score(process_data(data, 40))

# ------- TESTS --------

def test_process_data
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day14_test_input.txt").read.split("\n")

  count_hash1 = process_data(data, 1) #== "NCNBCHB"
  pp count_hash1["N"] == 2 &&
    count_hash1["C"] == 2 &&
    count_hash1["B"] == 2 &&
    count_hash1["H"] == 1


  count_hash2 = process_data(data, 2) #== "NBCCNBBBCBHCB"
  pp count_hash2["N"] == 2 &&
    count_hash2["C"] == 4 &&
    count_hash2["B"] == 6 &&
    count_hash2["H"] == 1

  # pp process_data(data, 3) == "NBBBCNCCNBBNBNBBCHBHHBCHB"
  # pp process_data(data, 4) == "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"

  count_hash10 = process_data(data, 10)
  pp count_hash10["N"] == 865 &&
    count_hash10["C"] == 298 &&
    count_hash10["B"] == 1749 &&
    count_hash10["H"] == 161

  pp quantity_score(process_data(data, 10)) == 1588

  pp quantity_score(process_data(data, 40)) == 2188189693529
end

test_process_data
