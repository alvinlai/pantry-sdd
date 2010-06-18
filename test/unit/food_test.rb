require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  context "A Food instance" do
    setup do
      @budget = Factory(:budget, :original_amount => 20)
      @food = Factory.build(:food, :cost => 30, :budget => @budget)
    end
    
    should "not be allowed when its cost exceeds it's budget" do
      @food.save
      assert @food.new_record? # not saved
    end
  end
end
