class CreateTransformations < ActiveRecord::Migration
  def change
    create_table :transformations do |t|
      t.string :pattern
      t.string :transform
      t.string :value

      t.timestamps null: false
    end
  end
end
