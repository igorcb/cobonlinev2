class CreateTypeTrades < ActiveRecord::Migration[7.0]
  def change
    create_table :type_trades do |t|
      t.string :name

      t.timestamps
    end
  end
end
