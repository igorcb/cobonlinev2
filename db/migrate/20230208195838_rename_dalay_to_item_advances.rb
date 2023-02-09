class RenameDalayToItemAdvances < ActiveRecord::Migration[7.0]
  def change
    rename_column :item_advances, :dalay, :delay
  end
end
