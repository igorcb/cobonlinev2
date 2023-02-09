class AddResidueToItemAdvances < ActiveRecord::Migration[7.0]
  def change
    add_column :item_advances, :residue, :decimal, precision: 9, scale: 2, default: 0
  end
end
