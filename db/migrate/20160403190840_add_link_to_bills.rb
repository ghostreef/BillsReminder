class AddLinkToBills < ActiveRecord::Migration
  def change
    add_column :bills, :link, :text
  end
end
