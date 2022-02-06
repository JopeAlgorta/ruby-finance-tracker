Rails.application.routes.draw do
  post 'user_stocks/copy/:id', to: 'user_stocks#copy', as: 'user_stocks_copy'
  resources :user_stocks, only: %i[create destroy]

  resources :friendships, only: %i[create destroy]
  
  devise_for :users
  resources :users, only: [:show]

  root 'welcome#index'

  get 'portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'
  
  get 'my_friends', to: 'users#my_friends'
  get 'search_friends', to: 'users#search'


end
