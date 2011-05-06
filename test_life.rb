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

end
