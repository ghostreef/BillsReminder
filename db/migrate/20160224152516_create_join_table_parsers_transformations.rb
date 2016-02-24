# rails g migration CreateJoinTableParsersTransformations parser transformation
class CreateJoinTableParsersTransformations < ActiveRecord::Migration
  def change
    create_join_table :parsers, :transformations do |t|
      # t.index [:parser_id, :transformation_id]
      # t.index [:transformation_id, :parser_id]
    end
  end
end
