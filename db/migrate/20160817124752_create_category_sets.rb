class CreateCategorySets < ActiveRecord::Migration
  def change
    create_table :category_sets do |t|
      t.string :name
      t.boolean :inclusive

      t.timestamps null: false
    end
  end
end
