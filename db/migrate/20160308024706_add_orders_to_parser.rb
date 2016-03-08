class AddOrdersToParser < ActiveRecord::Migration
  def change
    add_column :parsers, :search_order, :text
    add_column :parsers, :expected_order, :text
  end
end
