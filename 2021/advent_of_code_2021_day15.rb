def find_best_path_score(grid)
  best_path_hash, prev = find_best_path(grid)

  answer_grid = build_grid_from_hash(best_path_hash, grid.length, grid[0].length)
  print_path(answer_grid, prev, answer_grid.length, answer_grid[0].length)
  # print_grid(answer_grid)

  best_path_hash[[grid.length - 1, grid[0].length - 1]]
end

def find_best_path(grid)
  dist = Hash.new { Float::INFINITY }
  prev = Hash.new
  dist[[0,0]] = 0

  queue = [[0,0]]
  while !queue.empty?
    x,y = queue.shift
    current_loc = [x, y]

    neighbors = []
    neighbors << [x - 1, y] if x - 1 >= 0
    neighbors << [x + 1, y] if x + 1 < grid.length
    neighbors << [x, y - 1] if y - 1 >= 0
    neighbors << [x, y + 1] if y + 1 < grid[0].length

    neighbors.each do |neighbor|
      nx, ny = neighbor
      neighbor_loc = [nx,ny]

      calculated_dist = dist[current_loc] + grid[nx][ny]
      if calculated_dist < dist[neighbor_loc]
        dist[neighbor_loc] = calculated_dist
        prev[neighbor_loc] = [x,y]
        queue << [nx,ny]
      end
    end
  end
  return dist, prev
end

def build_grid_from_hash(hash, height, width)
  grid = Array.new(height) { Array.new(width) }
  hash.each do |k,v|
    x,y = k
    grid[x][y] = v
  end
  grid
end

def print_grid(grid)
  grid.each do |line|
    output = line.map do |spot|
      "%03d" % spot
    end.join(",")
    puts output
  end
end

def print_path(hash, prev, height, width)
  grid = Array.new(height) { Array.new(width, "X") }
  grid[height-1][width-1] = "."
  x, y = prev[[height-1, width-1]]
  while x
    grid[x][y] = "."
    x,y = prev[[x, y]]
  end

  grid.each do |line|
    puts line.join("")
  end
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day15_input.txt").read.split("\n").map { |line| line.split("").map(&:to_i) }
# 404 too high
pp find_best_path_score(data)


# ------- TESTS --------

def test_find_best_path
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day15_test_input.txt").read.split("\n").map { |line| line.split("").map(&:to_i) }

  pp find_best_path_score(data) == 40
end

test_find_best_path

def test_find_best_path2
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day15_test_input_2.txt").read.split("\n").map { |line| line.split("").map(&:to_i) }

  pp find_best_path_score(data) == 20
end

test_find_best_path2
