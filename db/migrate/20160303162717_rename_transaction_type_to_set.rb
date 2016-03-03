# rails g migration RenameTransactionTypeToSet
class RenameTransactionTypeToSet < ActiveRecord::Migration
  def change
    rename_column :transformations, :transformation_type, :set
  end
end
