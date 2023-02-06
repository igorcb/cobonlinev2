class AddTheReferencesToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :references_one_name, :string, limit: 100
    add_column :clients, :references_one_origin, :string, limit: 100
    add_column :clients, :references_one_phone, :string, limit: 100

    add_column :clients, :references_two_name, :string, limit: 100
    add_column :clients, :references_two_origin, :string, limit: 100
    add_column :clients, :references_two_phone, :string, limit: 100
    
    add_column :clients, :references_three_name, :string, limit: 100
    add_column :clients, :references_three_origin, :string, limit: 100
    add_column :clients, :references_three_phone, :string, limit: 100
  end
end
