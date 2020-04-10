Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end
  
  root "products#index"

  resources :card, only: [:new, :create, :show, :destroy] do
    collection do
      post 'show', to: 'card#show'
    end
  end

  resources :products, only: [:index, :new, :create, :show, :destroy, :edit, :update] do
    collection do
      get "search"
      get "pay"
      get "buy"
    end
  end

  resources :users, only: [:show]
  
end