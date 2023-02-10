class AddObservationToAdvance < ActiveRecord::Migration[7.0]
  def change
    add_column :advances, :observation, :text
  end
end
