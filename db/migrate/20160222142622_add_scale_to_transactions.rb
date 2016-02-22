class AddScaleToTransactions < ActiveRecord::Migration
  def change
    change_column :transactions, :amount, :decimal, precision: 8, scale: 2
  end
end
