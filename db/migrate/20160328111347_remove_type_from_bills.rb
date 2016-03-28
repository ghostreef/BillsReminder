# rails g migration RemoveTypeFromBills bill_type:string
class RemoveTypeFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :bill_type, :string
  end
end
