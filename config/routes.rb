Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants do
        resources :items, controller: 'merchant_items'
      end
      resources :items do
        resources :merchant, only: [:index], controller: 'item_merchant'
      end
    end
  end
end
