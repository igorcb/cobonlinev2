json.extract! current_account, :id, :city_id, :cost_id, :date_ocurrence, :type_launche, :price, :historic, :created_at,
              :updated_at
json.url current_account_url(current_account, format: :json)
