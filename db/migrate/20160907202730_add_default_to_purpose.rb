class AddDefaultToPurpose < ActiveRecord::Migration
  def change
    add_column :purposes, :default, :boolean
  end
end
