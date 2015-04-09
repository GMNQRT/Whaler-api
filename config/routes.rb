Rails.application.routes.draw do
  get 'home/index'
  get '/images' => 'image#list'
  get '/container' => 'container#list'
end
