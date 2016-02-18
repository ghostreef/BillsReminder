# rails g model Source name:string regex:string purpose:references
class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :regex
      t.references :purpose

      t.timestamps null: false
    end
  end
end
