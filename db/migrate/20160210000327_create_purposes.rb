class CreatePurposes < ActiveRecord::Migration
  def change
    create_table :purposes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
