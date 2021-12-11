def simulate_steps(octo_grid, steps)
  flashes = 0
  steps.times do |step_num|
    flashes += simulate_step(octo_grid)
  end

  return [octo_grid, flashes]
end

def simulate_step(grid)
  flashes = 0
  flashed = Array.new(10) { Array.new(10) { false } }
  width = grid.length
  height = grid[0].length
  to_increase = []

  width.times do |i|
    height.times do |j|
      grid[i][j] += 1
    end
  end

  width.times do |i|
    height.times do |j|
      if grid[i][j] > 9 && !flashed[i][j]
        to_increase << [i, j]

        while !to_increase.empty?
          new_i, new_j = to_increase.pop

          if flashed[new_i][new_j]
            grid[new_i][new_j] = 0
          else
            grid[new_i][new_j] += 1
          end

          if grid[new_i][new_j] > 9
            flashes += 1
            grid[new_i][new_j] = 0

            if !flashed[new_i][new_j]
              flashed[new_i][new_j] = true

              -1.upto(1) do |delta_i|
                -1.upto(1) do |delta_j|
                  next if delta_i == 0 && delta_j == 0
                  next if new_i + delta_i < 0 || new_i + delta_i >= width
                  next if new_j + delta_j < 0 || new_j + delta_j >= height

                  to_increase << [new_i + delta_i, new_j + delta_j]
                end
              end
            end
          end
        end
      end
    end
  end
  flashes
end

def find_all_flash(octo_grid)
  step = 0
  flashes = 0
  while flashes < 100
    flashes = simulate_step(octo_grid)
        pp octo_grid
    step += 1
  end
  step
end

def build_grid(input)
  octos = Array.new(10) { Array.new(10) }

  input.each_with_index do |line, i|
    line.split("").each_with_index do |num, j|
      octos[i][j] = num.to_i
    end
  end

  octos
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day11_input.txt").read.split("\n")

octo_grid = build_grid(data)

pp simulate_steps(octo_grid, 100)

octo_grid = build_grid(data)

pp find_all_flash(octo_grid)

# ------- TESTS --------

def test_simulate_ten_steps
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day11_test_input.txt").read.split("\n")

  octo_grid = build_grid(data)

  step10_answer_input = "0481112976
0031112009
0041112504
0081111406
0099111306
0093511233
0442361130
5532252350
0532250600
0032240000".split("\n")
  step10_answer = build_grid(step10_answer_input)

  grid, flashes = simulate_steps(octo_grid, 10)
  pp flashes == 204
  pp grid[0] == step10_answer[0]
  pp grid[9] == step10_answer[9]
end

test_simulate_ten_steps

def test_simulate_one_hundred_steps
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day11_test_input.txt").read.split("\n")

  octo_grid = build_grid(data)

  step100_answer_input = "0397666866
0749766918
0053976933
0004297822
0004229892
0053222877
0532222966
9322228966
7922286866
6789998766".split("\n")
  step100_answer = build_grid(step100_answer_input)

  grid, flashes = simulate_steps(octo_grid, 100)
  pp flashes == 1656
  pp grid[0] == step100_answer[0]
  pp grid[9] == step100_answer[9]
end

test_simulate_one_hundred_steps


def test_find_all_flash
  data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day11_test_input.txt").read.split("\n")

  octo_grid = build_grid(data)
  all_flash_step = find_all_flash(octo_grid)
  pp all_flash_step == 195
end

test_find_all_flash
