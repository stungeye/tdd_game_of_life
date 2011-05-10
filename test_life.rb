require 'minitest/autorun'
require_relative 'life'

describe Life do
  before do
    @empty_cells = []
    @empty_string = "-----\n" * 5
    @empty_life  = Life.new @empty_cells, 5, 5 

    @crowded_cells = [[0,0], [3,0], [4,0],
                      [3,1], [4,1],
                      [1,2], [2,2], [3,2],
                      [0,3], [1,3], [2,3], [3,3],
                      [0,4], [1,4], [2,4], [3,4], [4,4]]
    @crowded_string =  "*--**\n"
    @crowded_string << "---**\n"
    @crowded_string << "-***-\n"
    @crowded_string << "****-\n"
    @crowded_string << "*****\n"
    @crowded_life = Life.new @crowded_cells, 5, 5

    @lonely_cells = [[0,0], [2,0], [4,0],
                     [0,2], [2,2], [4,2],
                     [0,4], [2,4], [4,4]]
    # Lonely Cells:
    # *-*-*
    # -----
    # *-*-*
    # -----
    # *-*-*
    @lonely_life = Life.new @lonely_cells, 5, 5

    @underpopulated_cells = [[0,0],
                             [0,2],[1,2]]
    # Underpopulated Cells:
    # *---
    # ----
    # **--
    # ----
    @underpopulated_life = Life.new @underpopulated_cells, 4, 4

    @goldylocks_cells = [[1,1],
                        [0,2], [1,2], [2,2]]
    # Goldylock Cells:
    # ----
    # -*--
    # ***-
    # ----
    @goldylocks_life = Life.new @goldylocks_cells, 4, 4

    @static_cells = [[0,0], [1,0], [4,0], [5,0],
                     [0,1], [1,1], [4,1], [6,1],
                     [5,2],
                     [1,4], [2,4],
                     [0,5], [3,5],
                     [1,6], [2,6]]
    # Static Cells: (Includes block, boat and beehive)
    # **--**-
    # **--*-*
    # -----*-
    # -------
    # -**----
    # *--*---
    # -**----
    @static_life = Life.new @static_cells, 7, 7

    @periodic_one_cells = [[1,0], [5,0], [6,0],
                           [1,1], [5,1], 
                           [1,2],
                           [8,2],
                           [7,3], [8,3]]
    # Periodic One Cells (Blinker and Beacon)
    # -*---**--
    # -*---*---
    # -*------*
    # -------**
    @periodic_one_life = Life.new @periodic_one_cells, 9, 4

    @periodic_two_cells = [[5,0], [6,0],
                           [0,1], [1,1], [2,1], [5,1], [6,1],
                           [7,2], [8,2],
                           [7,3], [8,3]]
    # Periodic Two Cells (Blinker and Beacon)
    # -----**--
    # ***--**--
    # -------**
    # -------**
    @periodic_two_life = Life.new @periodic_two_cells, 9, 4
  end





  describe "when asked for its class" do
    it "must response with Life" do
      @empty_life.class.must_equal Life
    end
  end

  describe "when initialized with an empty array" do
    it "must contain an empty cells array" do
      @empty_life.cells.must_equal @empty_cells
    end
    it "must be able to to_s these cells to the correct string" do
      @empty_life.to_s.must_equal @empty_string
    end
  end

  describe "when created with a specific cell array" do
    it "must contain that same cell array" do
      @crowded_life.cells.must_equal @crowded_cells
    end
    it "must be able to to_s these cells to the correct string" do
      @crowded_life.to_s.must_equal @crowded_string
    end
  end

  describe "when cells have neighbours" do
    it "must raise an OutOfBounds exception if we request an out of bounds coordinate" do
      # Why is the lambda needed? Fails without it when the exception is raised.
      lambda {@crowded_life.neighbours(-1, -1)}.must_raise Life::OutOfBoundsError
    end
    it "must return the correct number of neighbours" do
      @crowded_life.neighbours(0, 0).must_equal 0
      @crowded_life.neighbours(1, 0).must_equal 1
      @crowded_life.neighbours(2, 0).must_equal 2
      @crowded_life.neighbours(4, 0).must_equal 3
      @crowded_life.neighbours(4, 3).must_equal 4
      @crowded_life.neighbours(2, 1).must_equal 5
      @crowded_life.neighbours(3, 3).must_equal 6
      @crowded_life.neighbours(1, 3).must_equal 7
      @crowded_life.neighbours(2, 3).must_equal 8
    end
  end

  describe "when created with only lonely cells" do
    it "must kill off all lonely cells" do
      @next_gen = @lonely_life.next_gen
      @next_gen.cells.must_equal @empty_cells
    end
  end

  describe "when live cells have less than 2 neighbours" do
    it "must kill off those cells" do
      @next_gen = @underpopulated_life.next_gen
      @next_gen.alive?(0,0).must_equal false
      @next_gen.alive?(0,2).must_equal false
      @next_gen.alive?(1,2).must_equal false
    end
  end

  describe "when all live cells have 2 or three neighbours" do
    it "must keep all those cells alive" do
      @next_gen = @goldylocks_life.next_gen
      (@next_gen.alive?(1,1) &&
      @next_gen.alive?(0,2) &&
      @next_gen.alive?(1,2) &&
      @next_gen.alive?(2,2)).must_equal true
    end
  end

  describe "when a dead cell has 3 neighbours" do
    it "must be revived" do
      @next_gen = @goldylocks_life.next_gen
      (@next_gen.alive?(0,1) &&
      @next_gen.alive?(2,1) &&
      @next_gen.alive?(1,3)).must_equal true
    end
  end

  describe "when all structres are static" do
    it "must leave these structures alone" do
      @next_gen = @static_life.next_gen
      @next_gen.cells.must_equal @static_cells
    end
  end

  describe "when structures are period two oscillators" do
    it "must properly transform to the second form" do
      @next_gen = @periodic_one_life.next_gen
      @next_gen.cells.must_equal @periodic_two_cells
    end
    it "must transform back from the second form to the first" do
      @next_gen = @periodic_two_life.next_gen
      @next_gen.cells.must_equal @periodic_one_cells
    end
  end

end


