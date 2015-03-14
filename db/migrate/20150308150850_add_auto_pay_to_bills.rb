class AddAutoPayToBills < ActiveRecord::Migration
  def change
    add_column :bills, :auto_pay, :boolean
  end
end
