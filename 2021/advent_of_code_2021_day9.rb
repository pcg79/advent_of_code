def find_low_points(points)
  _find_low_points(points)
end

def _find_low_points(points)
  width = points.length
  length = points[0].length

  [].tap do |output|
    width.times do |i|
      length.times do |j|
        output << points[i][j] if _low_point?(points, i, j)
      end
    end
  end
end

def _low_point?(points, i, j)
  point = points[i][j]
  width = points.length
  length = points[0].length

  north = (i == 0 || point < points[i - 1][j])
  east = (j == length - 1 || point < points[i][j + 1])
  south = (i == width - 1 || point < points[i + 1][j])
  west = (j == 0 || point < points[i][j - 1])

  north && east && south && west
end

def risk_level(points)
  points.inject(0) {|sum, i|  sum + i + 1 }
end

def find_basins(points)
  width = points.length
  length = points[0].length
  basins = []
  visited = {}
  width.times do |i|
    length.times do |j|
      basin = []
      next if points[i][j] == 9
      stack = [[i, j]]
      while !stack.empty?
        point_i, point_j = stack.pop
        next if visited["#{point_i},#{point_j}"]
        visited["#{point_i},#{point_j}"] = true

        basin << points[point_i][point_j]
        stack << [point_i - 1, point_j] if _not_nine?(points, point_i - 1, point_j)
        stack << [point_i, point_j - 1] if _not_nine?(points, point_i, point_j - 1)
        stack << [point_i + 1, point_j] if _not_nine?(points, point_i + 1, point_j)
        stack << [point_i, point_j + 1] if _not_nine?(points, point_i, point_j + 1)
      end

      basins << basin if !basin.empty?
    end
  end
  basins
end

def basin_score(basins)
  basins.map { |a| a.length }.sort.reverse[0..2].inject(1) { |product, i| product * i }
end

def _not_nine?(points, i, j)
  width = points.length
  length = points[0].length

  return false if i < 0 || i >= width || j < 0 || j >= length

  point = points[i][j]
  point < 9
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day9_input.txt").read.split("\n")
data = data.map do |line|
  line.split("").map(&:to_i)
end

points = find_low_points(data)

pp risk_level(points)

pp basin_score(find_basins(data))

# ===== TESTS =========

def test_find_low_points
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day9_test_input.txt").read.split("\n")
  data = data.map do |line|
    line.split("").map(&:to_i)
  end

  pp find_low_points(data).sort == [0,1,5,5]
end

test_find_low_points

def test_risk_level
  points = [1,0,5,5]
  pp risk_level(points) == 15
end

test_risk_level

def test_find_basins
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day9_test_input.txt").read.split("\n")
  data = data.map do |line|
    line.split("").map(&:to_i)
  end

  basins = find_basins(data)
  pp basins.length == 4
  pp basins.map { |a| a.length }.sort == [3,9,9,14]
end

test_find_basins

def test_basin_score
  basins = [[2, 1, 3],
    [4, 3, 2, 1, 0, 1, 2, 2, 4],
    [8, 7, 8, 7, 8, 8, 7, 6, 7, 8, 8, 8, 5, 6],
    [8, 7, 8, 7, 8, 6, 5, 6, 6]]

  pp basin_score(basins) == 1134
end

test_basin_score
