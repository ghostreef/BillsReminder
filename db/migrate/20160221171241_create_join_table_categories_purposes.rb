class CreateJoinTableCategoriesPurposes < ActiveRecord::Migration
  def change
    create_join_table :categories, :purposes do |t|
      # t.index [:category_id, :purpose_id]
      # t.index [:purpose_id, :category_id]
    end
  end
end
