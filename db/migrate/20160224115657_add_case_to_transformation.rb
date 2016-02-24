# rails g migration AddCaseToTransformation case_insensitive:boolean
class AddCaseToTransformation < ActiveRecord::Migration
  def change
    add_column :transformations, :case_insensitive, :boolean
  end
end
