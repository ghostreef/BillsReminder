class RemoveIssuerFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :issuer, :string
  end
end
