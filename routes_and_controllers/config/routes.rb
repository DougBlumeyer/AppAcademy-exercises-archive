Rails.application.routes.draw do
  resources :users, only: [:create, :destroy, :index, :show, :update]
  resources :contacts, only: [:create, :destroy, :show, :update]
  resources :contact_shares, only: [:create, :destroy]

  resources :users do
    resources :contacts, only: [:index]
    resources :comments, only: [:index]
  end

  # map.resources :users, :has_many => :comments
  # map.resources :contacts, :has_many => :comments
  # map.resources :contact_shares, :has_many => :comments

  # resources :users do
  #   resources :comments, only: [:index]
  # end
  # resources :contacts do
  #   resources :comments, only: [:index]
  # end

  resources :contact_shares do
    member { put 'favorite' }
    resources :comments, only: [:index]
  end

  resources :comments, only: [:create, :destroy, :show, :update]

#   get 'users(.:format)' => 'users#index', :as => 'users'
#   post 'users(.:format)' => 'users#create'
#   get 'users/new(.:format)' => 'users#new', :as => 'new_user'
#   get 'users/:id/edit(.:format)' => 'users#edit', :as => 'edit_user'
#   get 'users/:id' => 'users#show', :as => 'user'
#   patch 'users/:id(.:format)' => 'users#update'
#   put 'users/:id(.:format)' => 'users#update'
#   delete 'users/:id(.:format)' => 'users#destroy'

  resources :contacts do
    member { put 'favorite' }
    resources :comments, only: [:index]
  end

  root to: "users#index"
end
