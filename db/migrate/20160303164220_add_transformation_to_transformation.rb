class AddTransformationToTransformation < ActiveRecord::Migration
  def change
    add_column :transformations, :transformation_id, :integer
  end
end
