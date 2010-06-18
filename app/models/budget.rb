class Budget < ActiveRecord::Base
  has_many :foods
  
  def amount_left
    used_up = 0
    self.foods.collect{|f| f.cost}.each{|c| used_up += c}
    
    original_amount - used_up
  end
end
