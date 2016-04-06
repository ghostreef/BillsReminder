class AddTotalToSources < ActiveRecord::Migration
  def change
    add_column :sources, :total, :decimal
  end
end
