Spree::Core::Engine.routes.draw do
  scope 'dashboard' do
    get '/devices/activate' => 'devices#start_activate'
    post '/devices/activate' => 'devices#activate'
    resources :devices
  
    get '/' => 'dashboard#index'
  end
end
