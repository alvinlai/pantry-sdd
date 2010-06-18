class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.string :name
      t.integer :original_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
