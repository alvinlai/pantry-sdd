require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  context "A Budget instance" do
    setup do
      @budget = Factory(:budget, :original_amount => 30)
    end
    
    should "return it's amount left" do
      @food = Factory(:food, :cost => 20, :budget => @budget)

      assert 10, @budget.amount_left
    end
  end
end
