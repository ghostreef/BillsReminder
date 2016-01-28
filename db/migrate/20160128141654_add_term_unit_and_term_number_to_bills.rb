class AddTermUnitAndTermNumberToBills < ActiveRecord::Migration
  def change
    add_column :bills, :term_unit, :integer
    add_column :bills, :term_number, :integer
  end
end
