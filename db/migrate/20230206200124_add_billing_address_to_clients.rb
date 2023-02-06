class AddBillingAddressToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :billing_address, :string, limit: 100
    add_column :clients, :billing_number, :string, limit: 100
    add_column :clients, :billing_complement, :string, limit: 100
    add_column :clients, :billing_district, :string, limit: 100
    add_column :clients, :billing_city, :string, limit: 100
    add_column :clients, :billing_state, :string, limit: 100
    add_column :clients, :billing_zip, :string, limit: 100
  end
end
