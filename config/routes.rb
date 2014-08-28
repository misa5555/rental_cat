RentalCats::Application.routes.draw do
  root to: 'cats#index'

  resources :cats do 
    resources :cat_rental_requests, only: [ :new ]
  end

  resources :cat_rental_requests
  resources :users
  
  resources :sessions, only: [ :index, :create ]
  get 'login',     to: 'sessions#new',     as: "login"
  delete 'logout', to: 'sessions#destroy', as: "logout"
  delete 'logout/:id', to: 'sessions#logout_remote', as: "logout_remote"
  
  post "/cat_rental_requests/:id/approve", to: "cat_rental_requests#approve", as: :approve
  post "/cat_rental_requests/:id/deny", to: "cat_rental_requests#deny", as: :deny
end
