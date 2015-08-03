class AddExcessAmount < ActiveRecord::Migration
  def change
    add_column :insurances, :excess_amount, :decimal
  end
end
