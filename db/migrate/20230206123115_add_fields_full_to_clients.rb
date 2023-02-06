class AddFieldsFullToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :rg, :string, limit: 30
    add_column :clients, :cpf, :string, limit: 30
    add_column :clients, :birthday, :date
    add_column :clients, :credit_limit, :decimal, precision: 9, scale: 2, default: 0.00, null: false
    add_column :clients, :indication, :string, limit: 100
    add_column :clients, :status, :integer, default: 0
  end
end
