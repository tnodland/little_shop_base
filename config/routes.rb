Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new', as: :registration
  get '/profile', to: 'users#show', as: :profile
  namespace :profile do
    resources :orders, only: [:index]
  end

  resources :users, only: [:create, :edit]

  get '/cart', to: 'cart#show'

  resources :items, only: [:index, :show]

  get '/dashboard', to: 'merchants#show', as: :dashboard
  resources :merchants, only: [:index]

  namespace :admin do
    resources :users, only: [:index, :show]
    resources :merchants, only: [:show]
    resources :dashboard, only: [:index]
  end
end
