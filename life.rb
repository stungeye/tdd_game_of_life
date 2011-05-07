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
    0
  end

  def out_of_bounds x, y
    x < 0 || x >= @width || y < 0 || y >= @height
  end
end
