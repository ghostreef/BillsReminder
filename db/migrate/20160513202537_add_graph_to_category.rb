class AddGraphToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :graph, :boolean
  end
end
