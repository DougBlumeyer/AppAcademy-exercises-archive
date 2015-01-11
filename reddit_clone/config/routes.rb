Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show] do
    resources :subs, only: [:new]
  end
  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: [:new] do
    resources :posts, only: [:new]
  end

  resources :posts, except: [:new, :index, :destroy]

  root to: "sessions#new"
end
