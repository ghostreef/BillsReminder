# rails g migration AddSourceToBills source_id:integer
class AddSourceToBills < ActiveRecord::Migration
  def change
    add_column :bills, :source_id, :integer
  end
end
