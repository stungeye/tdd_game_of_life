# A simple [Shoes][sh] app to visualize 
# [my implementation](index.html) of [Conway's Game of life][gl].
#
#
# [sh]: http://stungeye.com/shoes2011/
# [gl]: http://en.wikipedia.org/wiki/Conway's_Game_of_Life

require 'life'

### Das Glasperlenspiel

# The `GlassBeadGame` wraps our `Life` class for use with Shoes.

class GlassBeadGame
  def initialize(cells, width, height, app)
    # The Shoes app, defined below this class, is saved as `@app`.
    @app = app
    @app.nostroke
    # Scale the cells according to the size of the grid.
    @cell_width = @app.width  / width 
    @cell_height = @app.height / height 
    @life = Life.new cells, width, height  
  end

  # Time keeps on ticking, ticking, into the future.
  def tick
    @life = @life.next_gen
  end

  # Clear the screen and redraw all the cells.
  def draw
    @app.clear
    @life.cells.each do |coordinates|
      x = coordinates[0]
      y = coordinates[1]
      # Cells that are going to live look different from dying cells.
      if @life.should_remain_alive?(x, y)
        @app.fill rgb(0x30, 0x30, 0xBB)
      else
        @app.fill rgb(0x50, 0x50, 0xFF)
      end
      @app.rect :left => x * @cell_width,
                :top => y * @cell_height, 
                :width => @cell_width,
                :height => @cell_height
    end
  end

  # Mouse clicks are our only user interactions.
  def click(button, x, y)
    # Left Click: Bring a dead cell to life.  
    if button == 1 
      x = x / @cell_width
      y = y / @cell_height
      @life.set_cell_alive! x, y
      self.draw
    # Right Click: Re-seed the grid.
    else
      randomize_cells!
    end
  end

  # When randomizing the cells, there's a 50% chance each cells will be alive.
  def randomize_cells!
    @life.height.times do |y|
      @life.width.times do |x|
        @life.set_cell_alive! x, y  if rand > 0.5
      end
    end
  end
end

#### The Shoes App

Shoes.app(:title => 'TDD Game of Life', :height => 300, :width => 300) do
  app = self
  gbg = GlassBeadGame.new [], 30, 30, app
  # To start, the Grid is seeded with random cells.
  gbg.randomize_cells!

  click do |button, x, y|
    gbg.click(button, x, y)  
  end

  # Attempt to generate and draw eight ticks a second.
  animate(8) do
    gbg.tick
    gbg.draw
  end
end

#### UNLICENSE
# _This is free and unencumbered software released into the public domain._
