class CreateCosts < ActiveRecord::Migration[7.0]
  def change
    create_table :costs do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
