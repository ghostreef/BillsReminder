class CreateParsers < ActiveRecord::Migration
  def change
    create_table :parsers do |t|
      t.string :name
      t.integer :status

      t.timestamps null: false
    end
  end
end
