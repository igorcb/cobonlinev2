class RenameDistrictToClients < ActiveRecord::Migration[7.0]
  def change
    rename_column :clients, :district, :home_district
  end
end
