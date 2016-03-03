class AddEnumComplexityToTransformation < ActiveRecord::Migration
  def change
    add_column :transformations, :complexity, :integer
  end
end
