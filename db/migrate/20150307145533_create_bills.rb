class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :issuer
      t.string :bill_type
      t.decimal :amount
      t.integer :cycle
      t.date :due_date
      t.text :description
      t.string :status

      t.timestamps null: false
    end
  end
end
