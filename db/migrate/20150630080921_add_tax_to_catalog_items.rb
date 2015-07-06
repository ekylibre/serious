class AddTaxToCatalogItems < ActiveRecord::Migration
  def change
    add_column :catalog_items, :tax, :string
  end
end
