class AddReferencesTypeTradeToClient < ActiveRecord::Migration[7.0]
  def change
    add_reference :clients, :type_trade, foreign_key: true
  end
end
