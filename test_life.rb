require 'minitest/autorun'
require_relative 'life'

describe Life do

  describe "when asked for its class" do
    it "must response with Life" do
      @life = Life.new [], 5, 5
      @life.class.must_equal Life
    end
  end

  describe "when initialized with an empty array" do
    before do
      @cells = []
      @life = Life.new @cells, 5, 5
    end
    it "must contain an empty cells array" do
      @life.cells.must_equal @cells
    end
    it "must be able to to_s these cells to the correct string" do
      output_string = "-----\n" * 5
      @life.to_s.must_equal output_string
    end
  end

  describe "when created with a specific cell array" do
    before do
      @cells = [[1,1],[2,2],[2,3]]
      @life = Life.new @cells, 5, 5
    end
    it "must contain that same cell array" do
      @life.cells.must_equal @cells
    end
    it "must be able to to_s these cells to the correct string" do
      output_string =  "-----\n"
      output_string << "-*---\n"
      output_string << "--*--\n"
      output_string << "--*--\n"
      output_string << "-----\n"
      @life.to_s.must_equal output_string
    end
  end

  describe "when created with only lonely cells" do
    it "must kill off all lonely cells" do
      @cells = [[0,0], [2,0], [4,0],
                [0,2], [2,2], [4,2],
                [0,4], [2,4], [4,4]]
      @life = Life.new @cells, 5, 5
      @next_gen = @life.next_gen
      @next_gen.cells.must_equal []
    end
  end

  describe "when cells have neighbours" do
    #it "must raise an OutOfBounds exception if we request an out of bounds coordinate" do
    #  @life = Life.new [], 5, 5
    #  @life.neighbours(-1, -1).must_raise RuntimeError
    #end
    it "must return the correct number of neighbours" do
      @cells = [[0,0], [3,0], [4,0],
                       [3,1], [4,1],
                [1,2], [2,2], [3,2],
                [1,3], [2,3], [3,3],
                [1,4], [2,4], [3,4]]
      @life = Life.new @cells, 5, 5
      @life.neighbours(0, 0).must_equal 0
    end
  end
end
