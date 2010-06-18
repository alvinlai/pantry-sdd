class Food < ActiveRecord::Base
  validate :must_not_exceed_budget
  belongs_to :budget
  
  def must_not_exceed_budget
    self.errors.add_to_base("food exceeded budget") unless self.budget.amount_left >= self.cost
  end
end
