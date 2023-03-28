Rails.application.routes.draw do
  
  devise_for :admins
  devise_for :users

  root to: 'products#index'

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]
  
  get 'order/show'
  post 'order/create'

  get 'add/cart/:product_id', to: 'carts#add', as: :add_to_cart
  get 'remove/:product_id', to: 'carts#remove', as: :remove_from_cart
  get 'remove_one/:product_id', to: 'carts#removeone', as: :remove_one_cart

  resource :cart, only: [:show]

  namespace :admin do
    root to: 'products#index'
    resources :products, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :orders, only: [:index]
  end

end
