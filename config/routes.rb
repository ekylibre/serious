Rails.application.routes.draw do
  devise_for :users

  namespace :backend do
    resources :actors
    resources :farms
    resources :games
    resources :historics
    resources :participants
    resources :scenarios
    resources :scenario_broadcasts
    resources :scenario_curves
    resources :users
    resources :catalog_items
    root to: 'scenarios#index'
  end

  resources :games
  resources :participants
  resources :farms
  resources :actors
  resources :loans
  resources :participations
  resources :shops do
    member do
      post :add
      delete :remove
      patch :decrement
      put :checkout
    end
  end
  resources :users

  root to: 'games#index'
end
