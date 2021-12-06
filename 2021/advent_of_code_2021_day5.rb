def find_overlaps(array)
  floor = Hash.new(0)
  array.each do |coords|
    start_c, end_c = coords.split(" -> ")
    x1, y1 = start_c.split(",").map(&:to_i)
    x2, y2 = end_c.split(",").map(&:to_i)

    deltax = if x1 == x2
      0
    elsif x1 > x2
      -1
    else
      1
    end

    deltay = if y1 == y2
      0
    elsif y1 > y2
      -1
    else
      1
    end

    len = [(y1 - y2).abs, (x1 - x2).abs].max + 1

    len.times do |i|
      floor["#{x1},#{y1}"] += 1

      x1 += deltax
      y1 += deltay
    end
  end

  floor
end

def count_overlaps(hash)
  count = 0
  hash.values.each do |num|
    count += 1 if num > 1
  end
  count
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day5_input.txt").read.split("\n")

pp count_overlaps(find_overlaps(data))
