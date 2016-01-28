class AddLastBillToBills < ActiveRecord::Migration
  def change
    add_column :bills, :last_bill, :boolean
  end
end
