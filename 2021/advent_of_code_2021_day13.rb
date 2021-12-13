def find_num_dots(data)
  dot_data, folds = parse_data(data)
  # folds = [folds[0]]
  matrix = build_matrix(dot_data)
  folds.each do |fold|
    matrix = fold(matrix, fold)
    # print_matrix(matrix)
  end

  count = count_dots(matrix)
  print_matrix(matrix)
  count
end

def fold(matrix, fold)
  direction, line = fold
  line = line.to_i

  if direction == "y"
    len = matrix.length

    if line < (len / 2)
      # folding down
      # We never did this
    else
      # folding up
      overlaps = (len - 1) - line
      overlaps.times do |delta|
        delta += 1 # we want 1 - 3, not 0 - 2, for example
        matrix[0].length.times do |x|
          matrix[line - delta][x] |= matrix[line + delta][x]
        end
      end

      new_matrix = []
      line.times do |y|
        new_matrix << matrix[y]
      end
    end
  else # direction = "x"
    len = matrix[0].length

    if line < (len / 2)
      # folding right
      # We never did this
    else
      # folding left
      overlaps = (len - 1) - line

      new_matrix = Array.new(matrix.length)
      overlaps.times do |delta|
        delta += 1 # we want 1 - 3, not 0 - 2, for example
        matrix.length.times do |y|
          matrix[y][line - delta] |= matrix[y][line + delta]
        end
      end

      new_matrix = []
      matrix.length.times do |y|
        row = []
        0.upto(line - 1) do |x|
          row << matrix[y][x]
        end
        new_matrix << row
      end
    end
  end

  new_matrix
end

def parse_data(data)
  dot_data = []
  folds = []
  at_fold = false
  data.each do |line|
    if line == ""
      at_fold = true
      next
    end

    if !at_fold
      dot_data << line.split(",").map(&:to_i)
    else
      match_data = line.match(/fold along (.)=(.*)/)
      folds << [match_data[1], match_data[2]]
    end
  end
  return dot_data, folds
end

# Data = X,Y  (X = left/right, Y = up/down
def build_matrix(dots)
  max_x = dots.map { |x,_| x }.max + 1
  max_y = dots.map { |_,y| y }.max + 1
  matrix = Array.new(max_y) { Array.new(max_x, false) }

  dots.each do |x, y|
    matrix[y][x] = true
  end

  matrix
end

def print_matrix(matrix)
  matrix.each do |line|
    line.each do |dot|
      print dot ? "#" : "."
    end
    puts
  end
end

def count_dots(matrix)
  count = 0
  matrix.each do |line|
    line.each do |dot|
      count += 1 if dot
    end
  end
  count
end


data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day13_input.txt").read.split("\n")

pp find_num_dots(data)

# ------- TESTS --------



# This fails now since Part 2 is about looking at the printed matrix and seeing the letters it made
# I don't know how to test for that
def test_find_num_dots
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day13_test_input.txt").read.split("\n")

  pp find_num_dots(data) == 17
end

test_find_num_dots
