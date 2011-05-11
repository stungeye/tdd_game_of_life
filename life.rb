class Life
  attr_reader :cells, :width, :height

  class OutOfBoundsError < ArgumentError; end

  def initialize(cells, width, height)
    @cells = cells
    @width = width
    @height = height
  end
  
  def to_s 
    output = ""
    @height.times do |y|
      @width.times do |x|
        output << (@cells.include?([x,y]) ? '*' : '-')
      end
      output << "\n"
    end
    output
  end

  def next_gen
    @next_cells = []
    @height.times do |y|
      @width.times do |x|
        @next_cells << [x,y]  if should_remain_alive?(x, y)
        @next_cells << [x,y]  if should_come_to_life?(x, y)
      end
    end
    Life.new @next_cells, @width, @height
  end

  def neighbours(x, y)
    raise OutOfBoundsError  if out_of_bounds x, y
    neighbours_found = 0
    @cells.each do |cx, cy|
      neighbours_found += 1  if neighbour? cx, cy, x, y
    end
    neighbours_found
  end

  def neighbour?(x1, y1, x2, y2)
    return false  if x1 == x2 && y1 == y2 # You are not your own neighbour!
    (x1 - x2).abs <= 1 && (y1 - y2).abs <= 1
  end

  def out_of_bounds(x, y)
    x < 0 || x >= @width || y < 0 || y >= @height
  end

  def should_remain_alive?(x,y)
    alive?(x,y) && (2..3).include?(neighbours(x,y))
  end

  def should_come_to_life?(x, y)
    dead?(x,y) && neighbours(x,y) == 3
  end

  def alive?(x, y)
    @cells.include?([x, y])
  end

  def dead?(x,y)
    !alive?(x, y)
  end

  def set_cell_alive(x, y)
    @cells << [x, y]  if !alive?(x,y)
  end
end
