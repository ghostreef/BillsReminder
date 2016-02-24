class AddEnumTypeToTransformation < ActiveRecord::Migration
  def change
    add_column :transformations, :transformation_type, :integer
  end
end
