class ChangeDefaultResidueToItemAdvances < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:item_advances, :residue, nil)
  end
end
