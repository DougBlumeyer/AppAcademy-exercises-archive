Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show, :index] do
    collection do
      get 'activate'
    end
    member do
      post 'adminify'
      post 'disadminify'
    end
  end
  resource :session, only: [:new, :create, :destroy]
  resources :bands do
    resources :albums, only: [:new]
  end
  resources :albums, except: [:index, :new] do
    resources :tracks, only: [:new]
  end
  resources :tracks, except: [:index, :new]
  resources :notes, only: [:new, :create, :destroy]

  resources :static_pages, only: [] do
    collection do
      get 'activation_sent'
    end
  end

  #root to: new_user_url
  root to: 'users#new'
end
