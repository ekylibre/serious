Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :games, only: [:show]
    end
  end

  namespace :backend do
    resources :games
    resources :game_turns
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
  resources :contract_natures, path: 'contract-natures'
  resources :deal_items, only: [:destroy], path: 'deal-items'
  resources :deals do
    collection do
      post :add_to_cart
    end
    member do
      post :checkout
      patch :change_quantity, path: 'change-quantity'
    end
  end
  resources :users
  resources :insurances

  root to: 'games#index'
end
