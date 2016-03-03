class RenameTransformToValue < ActiveRecord::Migration
  def change
    rename_column :transformations, :transform, :value
  end
end
