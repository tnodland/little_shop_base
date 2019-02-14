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
    resources :orders, only: [:index]
  end

  resources :users, only: [:create, :update]

  get '/cart', to: 'cart#show'

  resources :items, only: [:index, :show]

  get '/dashboard', to: 'merchants#show', as: :dashboard
  resources :merchants, only: [:index, :show]

  namespace :admin do
    put '/users/:id/enable', to: 'users#enable', as: :enable_user
    put '/users/:id/disable', to: 'users#disable', as: :disable_user
    resources :users, only: [:index, :show, :edit, :update]

    resources :merchants, only: [:show]
    resources :dashboard, only: [:index]
  end
end
