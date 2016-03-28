class RenameLastToFinal < ActiveRecord::Migration
  def change
    rename_column :bills, :last_bill, :final_bill
  end
end
