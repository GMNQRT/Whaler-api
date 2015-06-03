Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "users/sessions" }

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
      get 'history'
    end

    collection do
      get 'search'
    end
  end

end
