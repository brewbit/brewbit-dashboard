Spree::Core::Engine.routes.draw do
  get '/devices/activate' => 'devices#start_activate'
  post '/devices/activate' => 'devices#activate'
  resources :devices

  get '/dashboard' => 'dashboard#index'
end
