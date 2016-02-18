# rails g model Source name:string regex:string purpose:reference
class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :regex
      t.reference :purpose

      t.timestamps null: false
    end
  end
end
