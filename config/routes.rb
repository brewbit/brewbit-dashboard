Spree::Core::Engine.routes.draw do
  scope 'dashboard' do
    get '/' => 'devices#index'
    get '/devices/activate' => 'devices#start_activate'
    post '/devices/activate' => 'devices#activate'
    resources :devices do
      resources :sensors
    end
    resources :temp_profiles, except: [:show]
  end
  get  '/activate' => 'devices#start_activate'
  post '/activate' => 'devices#activate'
end
