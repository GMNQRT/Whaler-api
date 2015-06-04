Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :admin_registrations

  get 'home/index'

  resources :image do
    member do
      get 'history'
    end

    collection do
      get 'search'
    end
  end

  resources :container do
    member do
      get 'start'
    end
    member do
      get 'stop'
    end
    member do
      get 'pause'
    end
    member do
      get 'unpause'
    end
    member do
      get 'restart'
    end
  end

end
