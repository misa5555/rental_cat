RentalCats::Application.routes.draw do
  root to: 'cats#index'

  resources :cats do 
    resources :cat_rental_requests, only: [ :new ]
  end

  resources :cat_rental_requests

  post "/cat_rental_requests/:id/approve", to: "cat_rental_requests#approve", as: :approve
  post "/cat_rental_requests/:id/deny", to: "cat_rental_requests#deny", as: :deny
end
