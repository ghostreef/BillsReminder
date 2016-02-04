# rails g migration RemoveTagFromTags tag:string
class RemoveTagFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :tag, :string
  end
end
