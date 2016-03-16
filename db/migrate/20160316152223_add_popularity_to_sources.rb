class AddPopularityToSources < ActiveRecord::Migration
  def change
    # whoops wrong syntax, remove old columns
    remove_column :sources, :popularity
    remove_column :sources, :sources
    remove_column :sources, :integer
    add_column :sources, :popularity, :integer
  end
end
