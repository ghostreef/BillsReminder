class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount
      t.string :raw_description
      t.string :description
      t.references :source, index: true
      t.references :purpose, index: true

      t.timestamps null: false
    end
    add_foreign_key :transactions, :sources
    add_foreign_key :transactions, :purposes
  end
end
