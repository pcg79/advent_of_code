def find_all_paths(input)
  start = create_tree(input)

  paths = []

  _recurse(start, paths)

  paths.sort
end

def _recurse(node, paths, current_path = [])
  current_path << node.name
  node.visit!

  paths << current_path.dup if node.end?

  node.children.each do |child|
    _recurse(child, paths, current_path) unless child.visited?
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
    start_node.children << end_node
    end_node.children << start_node
  end

  tree_hash["start"]
end

class Node
  attr_accessor :children
  attr_reader :name, :size

  def initialize(name)
    @name = name
    @children = []
    @size = if name.upcase == name
      :large
    else
      :small
    end
    @visited = false
  end

  def visit!
    @visited = true if @size == :small
  end

  def unvisit!
    @visited = false
  end

  def visited?
    @visited
  end

  def end?
    name == "end"
  end
end


data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day12_input.txt").read.split("\n")

paths = find_all_paths(data)
# pp paths
pp paths.count

# ------- TESTS --------

def test_find_all_paths
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day12_test_input.txt").read.split("\n")

  paths = find_all_paths(data)

  output = [
    ["start", "A", "b", "A", "c", "A", "end"],
    ["start", "A", "b", "A", "end"],
    ["start", "A", "b", "end"],
    ["start", "A", "c", "A", "b", "A", "end"],
    ["start", "A", "c", "A", "b", "end"],
    ["start", "A", "c", "A", "end"],
    ["start", "A", "end"],
    ["start", "b", "A", "c", "A", "end"],
    ["start", "b", "A", "end"],
    ["start", "b", "end"]
  ]

  pp paths == output.sort
end

test_find_all_paths

def test_find_all_paths2
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day12_test_input2.txt").read.split("\n")

  paths = find_all_paths(data)

  output = [
    ["start", "HN", "dc", "HN", "end"],
    ["start", "HN", "dc", "HN", "kj", "HN", "end"],
    ["start", "HN", "dc", "end"],
    ["start", "HN", "dc", "kj", "HN", "end"],
    ["start", "HN", "end"],
    ["start", "HN", "kj", "HN", "dc", "HN", "end"],
    ["start", "HN", "kj", "HN", "dc", "end"],
    ["start", "HN", "kj", "HN", "end"],
    ["start", "HN", "kj", "dc", "HN", "end"],
    ["start", "HN", "kj", "dc", "end"],
    ["start", "dc", "HN", "end"],
    ["start", "dc", "HN", "kj", "HN", "end"],
    ["start", "dc", "end"],
    ["start", "dc", "kj", "HN", "end"],
    ["start", "kj", "HN", "dc", "HN", "end"],
    ["start", "kj", "HN", "dc", "end"],
    ["start", "kj", "HN", "end"],
    ["start", "kj", "dc", "HN", "end"],
    ["start", "kj", "dc", "end"]
  ]

  pp paths == output.sort
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

  pp paths.count == 226
end

test_find_all_paths3
