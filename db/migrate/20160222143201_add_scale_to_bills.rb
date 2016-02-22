class AddScaleToBills < ActiveRecord::Migration
  def change
    change_column :bills, :amount, :decimal, precision: 8, scale: 2
  end
end
