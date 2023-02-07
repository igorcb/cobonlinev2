class AddHomeAddressToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :home_address, :string, limit: 100
    add_column :clients, :home_number, :string, limit: 100
    add_column :clients, :home_complement, :string, limit: 100
    add_column :clients, :home_city, :string, limit: 100
    add_column :clients, :home_state, :string, limit: 100
    add_column :clients, :home_zip, :string, limit: 100
    add_column :clients, :home_link, :text
  end
end
