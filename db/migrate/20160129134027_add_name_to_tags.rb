# rails g migration AddNameToTags name:string
class AddNameToTags < ActiveRecord::Migration
  def change
    add_column :tags, :name, :string
  end
end
