Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]
      resources :categories, only: [:index, :show, :create]
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :transactions, only: [:index, :show, :create]
    end
  end
end