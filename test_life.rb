require 'minitest/autorun'
require_relative 'life'

describe Life do

  describe "when asked for its class" do
    it "must response with Life" do
      @life = Life.new []
      @life.class.must_equal Life
    end
  end

  describe "when initialized with an empty array" do
    it "must contain an empty cells array" do
      @life = Life.new []
      @life.cells.must_equal []
    end
  end

  describe "when created with a specific cell array" do
    it "must contain that same cell array" do
      cells = [[1,1],[2,2],[2,3]]
      @life = Life.new cells
      @life.cells.must_equal cells
    end
  end

end
