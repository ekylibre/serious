Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :games, only: [:show] do
        member do
          post :prepare
          post :confirm
          get :historic
        end
      end
    end
  end

  namespace :backend do
    resources :games
    resources :game_turns
    resources :participants
    resources :scenarios
    resources :scenario_broadcasts
    resources :scenario_curves
    resources :scenario_issues
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
      get :current_turn_broadcasts_and_curves
      get :turns
      post :prepare
      post :start
      post :cancel
      post :pause
      post :resume
      post :stop
      post :trigger_issue
    end
  end
  resources :participants
  resources :participants do
    member do
      get :affairs_with, to: 'participants#affairs_with', path: 'affairs_with/:other_id'
    end
  end
  resources :farms
  resources :actors
  resources :loans
  resources :participations
  resources :contract_natures, path: 'contract-natures'
  resources :deal_items, only: [:destroy], path: 'deal-items'
  resources :deals, except: [:index] do
    collection do
      post :add_to_cart
    end
    member do
      post :cancel
      post :checkout
      patch :change_quantity, path: 'change-quantity'
    end
  end
  resources :users
  resources :insurances

  root to: 'games#index'
end
