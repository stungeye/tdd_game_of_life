class Life
  attr_reader :cells

  class OutOfBoundsError < ArgumentError; end

  def initialize cells, width, height
    @cells = cells
    @width = width
    @height = height
  end
  
  def to_s 
    output = ""
    @height.times do |h|
      @width.times do |w|
        output << (@cells.include?([w,h]) ? '*' : '-')
      end
      output << "\n"
    end
    output
  end

  def next_gen
    Life.new [], @width, @height
  end

  def neighbours x, y
    raise OutOfBoundsError  if out_of_bounds x, y
    neighbours_found = 0
    @cells.each do |cx, cy|
      neighbours_found += 1  if neighbour? cx, cy, x, y
    end
    neighbours_found
  end

  def neighbour? x1, y1, x2, y2
    return false  if x1 == x2 && y1 == y2 # You are not your own neighbour!
    (x1 - x2).abs <= 1 && (y1 - y2).abs <= 1
  end

  def out_of_bounds x, y
    x < 0 || x >= @width || y < 0 || y >= @height
  end

  def alive? x, y
    @cells.include? [x, y]
  end
end
