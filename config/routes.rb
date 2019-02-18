Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new', as: :registration
  scope :profile do
    get '/', to: 'users#show', as: :profile
    get '/edit', to: 'users#edit', as: :edit_profile
  end
  namespace :profile do
    resources :orders, only: [:index, :create, :show]
  end

  resources :users, only: [:create, :update]

  get '/cart', to: 'cart#show'
  post '/cart/item/:id', to: 'cart#add', as: :cart_item
  post '/cart/addmoreitem/:id', to: 'cart#add_more_item', as: :cart_add_more_item
  delete '/cart', to: 'cart#destroy', as: :cart_empty
  delete '/cart/item/:id', to: 'cart#remove_more_item', as: :cart_remove_more_item
  delete '/cart/item/:id/all', to: 'cart#remove_all_of_item', as: :cart_remove_item_all

  resources :items, only: [:index, :show]

  get '/dashboard', to: 'merchants#show', as: :dashboard
  namespace :dashboard do
    resources :items, only: [:index]
  end

  resources :merchants, only: [:index]

  namespace :admin do
    put '/users/:id/enable', to: 'users#enable', as: :enable_user
    put '/users/:id/disable', to: 'users#disable', as: :disable_user
    resources :users, only: [:index, :show, :edit, :update] do
      resources :orders, only: [:index]
    end
    resources :merchants, only: [:show] do
      resources :items, only: [:index]
    end
    resources :dashboard, only: [:index]
  end
end
