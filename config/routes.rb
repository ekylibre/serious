Rails.application.routes.draw do
  resources :scenarios
  resources :games
  devise_for :users

  concern :list do
    collection do
      get :list
    end
  end

  namespace :backend do
    resources :games
    resources :scenarios
    resources :scenario_broadcasts
    resources :scenario_curves
    root to: "scenarios#index"
  end

  root to: "home#index"
end
