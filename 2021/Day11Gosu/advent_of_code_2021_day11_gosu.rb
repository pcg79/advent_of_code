require 'gosu'
require_relative 'octopus'

class OctoGrid < Gosu::Window
  attr_reader :width, :height, :num, :grid, :step

  def initialize(input)
    @step = 0
    @width = 800
    @height = 600
    super @width, @height, fullscreen: false

    @num = 10
    @grid = create_board(@width, @height, input)
    @running = false
    @max_counter = 75
    @counter = @max_counter
    # randomize_board
  end

  def button_down(button)
    case button
    when Gosu::KbEscape
      close
    when Gosu::KbSpace
      @running = !@running
    when Gosu::KbEqual
      @max_counter -= 50
    when Gosu::KbMinus
      @max_counter += 50
    end
  end

  def create_board(width, height, input)
    [].tap do |board|
      num.times do |i|
        board << Array.new
        num.times do |j|
          board[i][j] = Octopus.new(input[i][j], i, j, width / num, height / num)
        end
      end
    end
  end

  def update
    return unless @running

    @counter -= update_interval

    if @counter > 0
      return
    else
      @counter = @max_counter
    end

    simulate_step
    @step += 1
    print_board
  end

  def draw
    grid.each do |row|
      row.each do |octopus|
        octopus.draw
      end
    end
  end

  def simulate_step
    width = grid.length
    height = grid[0].length
    to_increase = []

    width.times do |i|
      height.times do |j|
        grid[i][j].grow!
        grid[i][j].reset_flash

      end
    end

    width.times do |i|
      height.times do |j|
        if grid[i][j].should_flash? && !grid[i][j].flashed?
          to_increase << [i, j]

          while !to_increase.empty?
            new_i, new_j = to_increase.pop

            if grid[new_i][new_j].flashed?
              grid[new_i][new_j].flash!
            else
              grid[new_i][new_j].grow!
            end

            if grid[new_i][new_j].should_flash?
              grid[new_i][new_j].level = 0

              if !grid[new_i][new_j].flashed?
                grid[new_i][new_j].flash!

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
  end

  def print_board
    levels = grid.map do |row|
      row.map do |octopus|
        octopus.level
      end
    end
    pp levels
  end

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

og = OctoGrid.new(octo_grid)
og.show
