Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }

  get 'home/index'

  get '/container' => 'container#list'


  resources :image do
    member do
      get 'history'
    end

    collection do
      get 'search'
    end
  end

end
