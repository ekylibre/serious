Rails.application.routes.draw do
  devise_for :users

  concern :list do
    collection do
      get :list
    end
  end

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
    root to: "scenarios#index"
  end

  root to: "home#index"
end
