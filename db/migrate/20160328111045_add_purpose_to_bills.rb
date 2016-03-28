# rails g migration AddPurposeToBills purpose_id:integer
class AddPurposeToBills < ActiveRecord::Migration
  def change
    add_column :bills, :purpose_id, :integer
  end
end
