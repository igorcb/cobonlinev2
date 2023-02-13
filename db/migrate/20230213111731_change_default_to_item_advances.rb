class ChangeDefaultToItemAdvances < ActiveRecord::Migration[7.0]
  def change
    change_column :item_advances, :delay, :decimal, precision: 9, scale: 2, null: true
    change_column :item_advances, :residue, :decimal, precision: 9, scale: 2, null: true
  end
end
