# rails g migration AddCategorySetToCategory category_set_id:integer
class AddCategorySetToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :category_set_id, :integer
  end
end
