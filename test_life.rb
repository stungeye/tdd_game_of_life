require 'minitest/autorun'
require_relative 'life'

describe Life do
  before do
    @empty_cells = []
    @empty_life  = Life.new @empty_cells, 5, 5 

    # Crowded Cells:
    # *--**
    # ---**
    # -***-
    # ****-
    # *****
    @crowded_cells = [[0,0], [3,0], [4,0],
                      [3,1], [4,1],
                      [1,2], [2,2], [3,2],
                      [0,3], [1,3], [2,3], [3,3],
                      [0,4], [1,4], [2,4], [3,4], [4,4]]
    @crowded_life = Life.new @crowded_cells, 5, 5

    # Lonely Cells:
    # *-*-*
    # -----
    # *-*-*
    # -----
    # *-*-*
    @lonely_cells = [[0,0], [2,0], [4,0],
                     [0,2], [2,2], [4,2],
                     [0,4], [2,4], [4,4]]
    @lonely_life = Life.new @lonely_cells, 5, 5
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
      output_string = "-----\n" * 5
      @empty_life.to_s.must_equal output_string
    end
  end

  describe "when created with a specific cell array" do
    it "must contain that same cell array" do
      @crowded_life.cells.must_equal @crowded_cells
    end
    it "must be able to to_s these cells to the correct string" do
      output_string =  "*--**\n"
      output_string << "---**\n"
      output_string << "-***-\n"
      output_string << "****-\n"
      output_string << "*****\n"
      @crowded_life.to_s.must_equal output_string
    end
  end

  describe "when created with only lonely cells" do
    it "must kill off all lonely cells" do
      @next_gen = @lonely_life.next_gen
      @next_gen.cells.must_equal []
    end
  end

  describe "when cells have neighbours" do
    #it "must raise an OutOfBounds exception if we request an out of bounds coordinate" do
    #  @crowded_life.neighbours(-1, -1).must_raise RuntimeError
    #end
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
end


