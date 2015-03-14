class RemoveStatusFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :status, :string
  end
end
