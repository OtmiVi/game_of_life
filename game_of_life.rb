require 'gosu'

# Grid size
GRID_SIZE = 100
CELL_SIZE = 70

# Conway's Game of Life logic
class GameOfLife
  def initialize
    @grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, false) }
    randomize_grid
  end

  def randomize_grid
    GRID_SIZE.times do |x|
      GRID_SIZE.times do |y|
        @grid[x][y] = rand(2) == 1
      end
    end
  end

  def next_generation
    new_grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, false) }

    GRID_SIZE.times do |x|
      GRID_SIZE.times do |y|
        alive_neighbors = count_alive_neighbors(x, y)
        if @grid[x][y]
          new_grid[x][y] = alive_neighbors == 2 || alive_neighbors == 3
        else
          new_grid[x][y] = alive_neighbors == 3
        end
      end
    end

    @grid = new_grid
  end

  def count_alive_neighbors(x, y)
    directions = [-1, 0, 1]
    neighbors = 0

    directions.each do |dx|
      directions.each do |dy|
        next if dx == 0 && dy == 0
        nx, ny = x + dx, y + dy
        neighbors += 1 if nx.between?(0, GRID_SIZE - 1) && ny.between?(0, GRID_SIZE - 1) && @grid[nx][ny]
      end
    end

    neighbors
  end

  def draw(window)
    GRID_SIZE.times do |x|
      GRID_SIZE.times do |y|
        color = @grid[x][y] ? Gosu::Color::BLACK : Gosu::Color::WHITE
        window.draw_rect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE, color)
      end
    end
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(GRID_SIZE * CELL_SIZE, GRID_SIZE * CELL_SIZE + 50, false)
    self.caption = "Conway's Game of Life"
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
      @game.randomize_grid
    end
  end
end

window = GameWindow.new
window.show
