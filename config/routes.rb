Rails.application.routes.draw do
  devise_for :users

  namespace :backend do
    resources :actors
    resources :farms
    resources :games
    resources :game_turns
    resources :historics
    resources :participants
    resources :scenarios
    resources :scenario_broadcasts
    resources :scenario_curves
    resources :users
    resources :catalog_items
    root to: 'scenarios#index'
  end

  resources :games do
    collection do
      get :current_turn, to: 'games#show_current_turn', path: 'current-turn'
    end
    member do
      get :current_turn, to: 'games#show_current_turn', path: 'current-turn'
      post :run
    end
  end
  resources :participants
  resources :farms
  resources :actors
  resources :loans
  resources :participations
  resources :contracts
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
