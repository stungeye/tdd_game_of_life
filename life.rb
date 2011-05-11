# **Life** is a class that implement's [Conway's Game of life][gl],
# a simple [cellular automaton][ca].
#
# The Game of Life is "played" on a two-dimensional grid of square cells, each
# of which is in one of two possible states, alive or dead. Every cell interacts
# with its eight neighbours.
#
# The game plays out in "ticks". At each step in time, the following 
# transitions occur:
#
# * Any live cell with fewer than two live neighbours dies.
# * Any live cell with two or three live neighbours lives.
# * Any live cell with more than three live neighbours dies.
# * Any dead cell with exactly three live neighbours becomes a live cell.
#
# I implemented this code in a [Test Driven][td] manner in order to practice 
# TDD and to play with the new Ruby testing library [Minitest][mt].
#
# The tests can be found [here](test_life.html).
#
# The code has been testing using Ruby 1.9.2 and 1.8.7.
#
# [gl]: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
# [ca]:  http://en.wikipedia.org/wiki/Cellular_automaton
# [td]: http://en.wikipedia.org/wiki/Test-driven_development
# [mt]:  http://github.com/seattlerb/minitest

#### Let's Begin

# Our class has three public getters for retrieving the array of live cells,
# and the grid dimensions. Unlike a the 'pure' definition of the game, our 
# grid is not-infinite in size.

class Life
  attr_reader :cells, :width, :height

  # `OutOfBoundsError` is a custom Exception that can be thrown by the 
  # neighbours method.
  class OutOfBoundsError < ArgumentError; end

  # When constructing our object we need to supply an array of cells, along with 
  # the dimensions of the grid.
  #
  # The array of cells represents only live cells, where each cell is represented 
  # by an array of size 2. The zeroth position representing the x coordinate of 
  # the cell and the first position representing the y coordinate of the cell.
  #
  # So, for example, if you had two lives cells, one at x=1 and y=0 and another 
  # at x=2 and y=3, the array would be: `[[1, 0], [2, 3]]`
  def initialize(cells, width, height)
    @cells = cells
    @width = width
    @height = height
  end

  ####These are the People in Your Neighbourhood

  # Given two sets of x, y coordinates, are they neighbours?
  def neighbour?(x1, y1, x2, y2)
    # You are not your own neighbour!
    return false  if x1 == x2 && y1 == y2 
    # A neighbour is an adjecent cell. In otherword, neither our delta x or our
    # delta y can be greater than one.
    (x1 - x2).abs <= 1 && (y1 - y2).abs <= 1
  end

  # The `neighbours` method returns the number of neigbouring live cells for any
  # x, y coordinate in the grid.
  def neighbours(x, y)
    # If the x, y arguments are out of bounds we raise our custom `OutOfBoundError`.
    raise OutOfBoundsError  if out_of_bounds x, y
    neighbours_found = 0
    # This method is compuationally expensive. As such, the performance degrades 
    # as our cells count grows.
    @cells.each do |cx, cy|
      neighbours_found += 1  if neighbour? cx, cy, x, y
    end
    neighbours_found
  end

  #### Life, The Next Generation

  # The `next_gen` method generates the outcome of the next "tick" or time-step in
  # the game.
  def next_gen
    # We start with an empty cell array...
    @next_cells = []
    @height.times do |y|
      @width.times do |x|
        # ...and we add cells that either depending on the rules of the game.
        @next_cells << [x,y]  if should_remain_alive?(x, y) || 
                                 should_come_to_life?(x, y)
      end
    end
    # Finally we return a new Life object instantiated with the new batch of cells.
    Life.new @next_cells, @width, @height
  end

  #### The Rules of Life

  # Cells that are alive should remain so if they have 2 or 3 neighbours.
  def should_remain_alive?(x,y)
    alive?(x,y) && (2..3).include?(neighbours(x,y))
  end

  # Cells that are dead should come to life if they have exactly 3 neighbours.
  def should_come_to_life?(x, y)
    dead?(x,y) && neighbours(x,y) == 3
  end

  #### Helper Methods

  # A cell at a particular x,y coordinate is alive if it can be found in our 
  # array of `@cells`.
  def alive?(x, y)
    @cells.include?([x, y])
  end

  # A cell at a particular x,y coordinate is dead if it is not alive. :)
  def dead?(x,y)
    !alive?(x, y)
  end

  # Allow us to bring specific cells to life, as long as they aren't already alive.
  def set_cell_alive(x, y)
    @cells << [x, y]  if !alive?(x,y)
  end
 
  # Our grid bounaries are zero-based and depend on our `@width` and `@height`.
  def out_of_bounds(x, y)
    x < 0 || x >= @width || y < 0 || y >= @height
  end
 
  # Our Life object can output a string representation of itself. Live cells are
  # shown as asteriks and dead cells as minus signs.
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
end
