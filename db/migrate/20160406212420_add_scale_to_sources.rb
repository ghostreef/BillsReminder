class AddScaleToSources < ActiveRecord::Migration
  def change
    change_column :sources, :total, :decimal, precision: 8, scale: 2
  end
end
