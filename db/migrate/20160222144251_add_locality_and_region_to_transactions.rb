class AddLocalityAndRegionToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :locality, :string
    add_column :transactions, :region, :string
  end
end