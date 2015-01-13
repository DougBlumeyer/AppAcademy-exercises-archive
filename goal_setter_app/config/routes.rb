Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  resources :goals, only: [:create, :show] do
    member do
      patch 'complete'
    end
  end
end
