# rails g migration RenamePatternToRegex
class RenamePatternToRegex < ActiveRecord::Migration
  def change
    rename_column :transformations, :pattern, :regex
  end
end
