def find_illegal_chars(input)
  hash = {
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">",
  }

  illegal_chars = []
  openings = hash.keys
  input.each do |line|
    stack = []
    line.each_char do |char|
      if openings.include?(char)
        stack << hash[char]
      elsif char != stack.pop
        illegal_chars << char
        next
      end
    end
  end
  illegal_chars
end

def find_completion_chars(input)
  hash = {
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">",
  }

  completion_chars = []
  openings = hash.keys
  input.each do |line|
    stack = []
    line.each_char do |char|
      if openings.include?(char)
        stack << hash[char]
      elsif char != stack.pop
        stack = []
        break
      end
    end
    completion_chars << stack.reverse if !stack.empty?
  end
  completion_chars
end

def syntax_score(input)
  hash = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  input.map { |char| hash[char] }.sum
end

def completion_score(input)
  hash = {
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }
  sum = 0
  input.each { |char| sum = (sum * 5) + hash[char] }
  sum
end

def find_completion_score(scores)
  scores.sort[scores.length / 2]
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day10_input.txt").read.split("\n")

pp syntax_score( find_illegal_chars(data) )

completion_chars = find_completion_chars(data)
pp find_completion_score( completion_chars.map { |chars| completion_score(chars) } )


def test_find_illegal_chars
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day10_test_input.txt").read.split("\n")

  pp find_illegal_chars(data).length == 5
  pp find_illegal_chars(data).sort == [")", ")", ">", "]", "}"]
end

test_find_illegal_chars

def test_syntax_score
  data = [")", ")", "]", "}", ">"]

  pp syntax_score(data) == 26397
end

test_syntax_score

def test_find_completion_chars
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day10_test_input.txt").read.split("\n")

  answer = [
    %w|} } ] ] ) } ) ]|,
    %w|) } > ] } )|,
    %w|} } > } > ) ) ) )|,
    %w|] ] } } ] } ] } >|,
    %w|] ) } >|
  ]
  output = find_completion_chars(data)
  pp output.length == 5
  pp output[0].length == 8
  pp output[1].sort == answer[1].sort
end

test_find_completion_chars

def test_completion_score
  input = %w|] ) } >|

  pp completion_score(input) == 294
end

test_completion_score

def test_find_completion_score
  scores = [288957, 5566, 1480781, 995444, 294]

  pp find_completion_score(scores) == 288957
end
