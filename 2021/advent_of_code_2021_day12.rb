def find_all_paths(input)
  start = create_tree(input)

  paths = []

  _recurse(start, paths)

  paths.sort
end

def _recurse(node, paths, current_path = [], small_visited_twice = false)
  current_path << node.name
  node.visit!
  small_visited_twice = true if node.visited == 2
  paths << current_path.dup if node.end?

  node.children.each do |child|
    if child.visited < 1 || !small_visited_twice
      _recurse(child, paths, current_path, small_visited_twice)
    end
  end

  node.unvisit!
  current_path.pop
end

def create_tree(input)
  tree_hash = {}
  input.each do |line|
    start_name, end_name = line.split("-")
    start_node = tree_hash[start_name] ||= Node.new(start_name)
    end_node = tree_hash[end_name] ||= Node.new(end_name)
    start_node.children << end_node unless end_name == "start" || start_name == "end"
    end_node.children << start_node unless start_name == "start" || end_name == "end"
  end

  tree_hash["start"]
end

class Node
  attr_accessor :children
  attr_reader :name, :size, :visited

  def initialize(name)
    @name = name
    @children = []
    @size = if name.upcase == name
      :large
    else
      :small
    end
    @visited = 0
  end

  def visit!
    @visited += 1 if @size == :small
  end

  def unvisit!
    @visited -= 1 if @size == :small
  end

  def visited?
    @visited == 2
  end

  def end?
    name == "end"
  end

  def to_s
    "name=#{name}, children=#{children.map(&:name)}"
  end
end


data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day12_input.txt").read.split("\n")

paths = find_all_paths(data)

# needs to be lower than 119026
pp paths.count



# ------- TESTS --------

def test_find_all_paths
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day12_test_input.txt").read.split("\n")

  paths = find_all_paths(data)

  output = [
    ["start", "A", "b", "A", "b", "A", "c", "A", "end"],
    ["start", "A", "b", "A", "b", "A", "end"],
    ["start", "A", "b", "A", "b", "end"],
    ["start", "A", "b", "A", "c", "A", "b", "A", "end"],
    ["start", "A", "b", "A", "c", "A", "b", "end"],
    ["start", "A", "b", "A", "c", "A", "c", "A", "end"],
    ["start", "A", "b", "A", "c", "A", "end"],
    ["start", "A", "b", "A", "end"],
    ["start", "A", "b", "d", "b", "A", "c", "A", "end"],
    ["start", "A", "b", "d", "b", "A", "end"],
    ["start", "A", "b", "d", "b", "end"],
    ["start", "A", "b", "end"],
    ["start", "A", "c", "A", "b", "A", "b", "A", "end"],
    ["start", "A", "c", "A", "b", "A", "b", "end"],
    ["start", "A", "c", "A", "b", "A", "c", "A", "end"],
    ["start", "A", "c", "A", "b", "A", "end"],
    ["start", "A", "c", "A", "b", "d", "b", "A", "end"],
    ["start", "A", "c", "A", "b", "d", "b", "end"],
    ["start", "A", "c", "A", "b", "end"],
    ["start", "A", "c", "A", "c", "A", "b", "A", "end"],
    ["start", "A", "c", "A", "c", "A", "b", "end"],
    ["start", "A", "c", "A", "c", "A", "end"],
    ["start", "A", "c", "A", "end"],
    ["start", "A", "end"],
    ["start", "b", "A", "b", "A", "c", "A", "end"],
    ["start", "b", "A", "b", "A", "end"],
    ["start", "b", "A", "b", "end"],
    ["start", "b", "A", "c", "A", "b", "A", "end"],
    ["start", "b", "A", "c", "A", "b", "end"],
    ["start", "b", "A", "c", "A", "c", "A", "end"],
    ["start", "b", "A", "c", "A", "end"],
    ["start", "b", "A", "end"],
    ["start", "b", "d", "b", "A", "c", "A", "end"],
    ["start", "b", "d", "b", "A", "end"],
    ["start", "b", "d", "b", "end"],
    ["start", "b", "end"]
]

  pp paths.count == output.count
end

test_find_all_paths

def test_find_all_paths2
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day12_test_input2.txt").read.split("\n")

  paths = find_all_paths(data)

  pp paths.count == 103
end

test_find_all_paths2

def test_find_all_paths3
  data = [
    "fs-end",
    "he-DX",
    "fs-he",
    "start-DX",
    "pj-DX",
    "end-zg",
    "zg-sl",
    "zg-pj",
    "pj-he",
    "RW-he",
    "fs-DX",
    "pj-RW",
    "zg-RW",
    "start-pj",
    "he-WI",
    "zg-he",
    "pj-fs",
    "start-RW"
  ]

  paths = find_all_paths(data)
  pp paths.count == 3509
end

test_find_all_paths3
