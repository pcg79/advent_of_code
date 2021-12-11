class Octopus
  attr_reader :width, :height, :x, :y
  attr_accessor :level, :flashed
  def initialize(level, x, y, width, height)
    @x = x * width
    @y = y * height
    @width = width
    @height = height
    @level = level
    @flashed = false
  end

  def grow!
    @level += 1
  end

  def flash!
    @level = 0
    @flashed = true
  end

  def flashed?
    @flashed
  end

  def reset_flash
    @flashed = false
  end

  def should_flash?
    @level > 9
  end

  def draw
    Gosu.draw_rect(x, y, width, height, color)
  end

  private

  # 0 = Black
  # 9+ = White
  def color
    color_level = [@level, 10].min
    Gosu::Color.new(25.5 * (color_level), 255, 255, 255)
  end
end
