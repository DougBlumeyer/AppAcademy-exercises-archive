AuthDemo::Application.routes.draw do
  resource :session, only: [:create, :destroy, :new]
  resource :user, only: [:create, :new, :show] do
    resource :counter, only: [:update]
  end

  Rails.application.routes.draw do
    get 'static_pages/home'
    get 'static_pages/about'
    get 'static_pages/contact'
  end
end
