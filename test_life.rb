require 'minitest/autorun'
require_relative 'life'

describe Life do
  before do
    @life = Life.new
  end

  describe "when asked for its class" do
    it "must response with Life" do
      @life.class.must_equal Life
    end
  end

end
