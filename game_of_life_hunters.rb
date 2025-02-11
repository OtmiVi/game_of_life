require 'gosu'

# Grid size
GRID_SIZE = 50
CELL_SIZE = 15
FOOD_COUNT = 100
HUNTER_COUNT = 10

class GameOfLife
  attr_reader :grid, :hunters

  def initialize
    @grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, :empty) }
    @hunters = []
    
    FOOD_COUNT.times { randomize_food }
    
    HUNTER_COUNT.times { add_random_hunter }
  end

  def randomize_food
    x, y = rand(GRID_SIZE), rand(GRID_SIZE)
    while @grid[x][y] != :empty
      x, y = rand(GRID_SIZE), rand(GRID_SIZE)
    end
    @grid[x][y] = :food
  end

  def add_random_hunter
    x, y = rand(GRID_SIZE), rand(GRID_SIZE)
    while @grid[x][y] != :empty
      x, y = rand(GRID_SIZE), rand(GRID_SIZE)
    end
    @hunters << { x: x, y: y }
    @grid[x][y] = :hunter
  end

  def move_hunters
    @hunters.each do |hunter|
      x, y = hunter[:x], hunter[:y]
      direction = rand(4) # Move in one of four directions: 0=up, 1=right, 2=down, 3=left
      case direction
      when 0 then hunter[:y] = (y - 1) % GRID_SIZE # Up
      when 1 then hunter[:x] = (x + 1) % GRID_SIZE # Right
      when 2 then hunter[:y] = (y + 1) % GRID_SIZE # Down
      when 3 then hunter[:x] = (x - 1) % GRID_SIZE # Left
      end

      if @grid[hunter[:x]][hunter[:y]] == :food
        @grid[hunter[:x]][hunter[:y]] = :hunter
        randomize_food
      else
        @grid[hunter[:x]][hunter[:y]] = :hunter
      end
    end
  end

  def next_generation
    move_hunters
  end

  def draw(window)
    GRID_SIZE.times do |x|
      GRID_SIZE.times do |y|
        color = case @grid[x][y]
                when :empty then Gosu::Color::WHITE
                when :food then Gosu::Color::GREEN
                when :hunter then Gosu::Color::RED
                end
        window.draw_rect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE, color)
      end
    end
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(GRID_SIZE * CELL_SIZE, GRID_SIZE * CELL_SIZE + 50, false)
    self.caption = "Food and Hunters Simulation"
    @game = GameOfLife.new
  end

  def update
    @game.next_generation
  end

  def draw
    @game.draw(self)
  end

  def button_down(id)
    case id
    when Gosu::KbSpace
      @game.next_generation
    when Gosu::KbR
      @game = GameOfLife.new
    end
  end
end

window = GameWindow.new
window.show
