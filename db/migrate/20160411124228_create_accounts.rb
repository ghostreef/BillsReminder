class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :hint
      t.string :name

      t.timestamps null: false
    end
  end
end
