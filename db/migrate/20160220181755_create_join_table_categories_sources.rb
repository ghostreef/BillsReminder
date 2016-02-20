# rails g migration CreateJoinTableCategoriesSources category source
# not sure why contents are commented out, but the table is correct
class CreateJoinTableCategoriesSources < ActiveRecord::Migration
  def change
    create_join_table :categories, :sources do |t|
      # t.index [:category_id, :source_id]
      # t.index [:source_id, :category_id]
    end
  end
end
