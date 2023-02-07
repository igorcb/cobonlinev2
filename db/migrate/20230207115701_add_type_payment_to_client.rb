class AddTypePaymentToClient < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :type_payment, :integer, default: 0
  end
end
