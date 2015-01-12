Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show] do
    resources :subs, only: [:create]
  end
  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: [:create] do
    resources :posts, only: [:create]
  end

  resources :posts, except: [:create, :index, :destroy] do
    resources :comments, only: [:new]
    member do
      post 'upvote'
      post 'downvote'
    end
  end

  resources :comments, only: [:create, :show] do
    member do
      post 'upvote'
      post 'downvote'
    end
  end

  root to: "sessions#new"
end
