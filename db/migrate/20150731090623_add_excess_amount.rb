class AddExcessAmount < ActiveRecord::Migration
  def change
    add_column :insurances, :excess_amount, :decimal, precision: 19, scale: 4
  end
end
