Rails.application.routes.draw do
  resources :type_trades
  match "/search_current_accounts", :controller => "current_accounts", :action => "search", via: [:get]
  match "/result_search_current_accounts" => "current_accounts#search_logistic", via: [:get]
  match "/launch_current_accounts" => "current_accounts#launch_current", via: [:get, :post]
  match '/advance_dashboard',  to: 'static_pages#advance_dashboard', via: [:get, :post]
  match '/advance_search',  to: 'static_pages#advance_search', via: [:get, :post]

  resources :current_accounts do
    collection do
      get 'index_user_operator'
    end
  end

  resources :costs
  match 'recalculation/:id' => "advances#recalculation", :as => 'recalculation', via: [:get]
    
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  resources :item_advances
  resources :advances do
    member do
      get "print"
    end
  end
  resources :clients
  resources :holidays
  resources :cities
  
  devise_for :users

  match "/get_client_for_city", :controller => "advances", :action => "get_client_for_city", via: [:get]
  match '/dashboard',  to: 'static_pages#dashboard',         via: 'get'

  get "static_pages/index"  
  root to: "static_pages#index" 
end
