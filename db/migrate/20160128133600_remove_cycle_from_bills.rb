# rails g migration RemoveCycleFromBills cycle:integer
class RemoveCycleFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :cycle, :integer
  end
end
