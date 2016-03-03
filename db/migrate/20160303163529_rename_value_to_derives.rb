class RenameValueToDerives < ActiveRecord::Migration
  def change
    rename_column :transformations, :value, :derives
  end
end
