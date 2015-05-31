Rails.application.routes.draw do
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
