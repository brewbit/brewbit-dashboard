Spree::Core::Engine.routes.draw do
  resources :devices

  get '/dashboard' => 'dashboard#index'
end
