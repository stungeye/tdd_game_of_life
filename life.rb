class Life
  attr_reader :cells

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
end
