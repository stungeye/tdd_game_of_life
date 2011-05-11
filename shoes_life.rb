require 'life'

class GlassBeadGame
  def initialize(cells, width, height, app)
    @app = app
    @cell_width = @app.width / width
    @cell_height = @app.height / height
    @life = Life.new cells, width, height  
  end

  def tick
    @life = @life.next_gen
  end

  def draw
    @app.clear
    @life.cells.each do |coordinates|
      x = coordinates[0]
      y = coordinates[1]
      @app.stroke rgb(0x30, 0x30, 0x40)
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

  def click(button, x, y)
    if button == 1 
      x = x / @cell_width
      y = y / @cell_height
      @life.set_cell_alive x, y
      self.draw
    else
      randomize_cells!
    end
  end

  def randomize_cells!
    @life.height.times do |y|
      @life.width.times do |x|
        @life.set_cell_alive x, y  if rand > 0.5
      end
    end
  end
end

Shoes.app(:title => 'TDD Game of Life', :height => 600, :width => 600) do
  
  app = self
  gbg = GlassBeadGame.new [], 30, 30, app
  gbg.randomize_cells!

  click do |button, x, y|
    gbg.click(button, x, y)  
  end

  animate(8) do
    gbg.tick
    gbg.draw
  end
end
