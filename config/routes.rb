Spree::Core::Engine.routes.draw do
  scope 'dashboard' do
    get '/' => 'devices#index'
    get '/devices/activate' => 'devices#start_activate'
    post '/devices/activate' => 'devices#activate'
    resources :devices do
      resources :sensors
      resources :device_commands, path: :commands, as: :commands, except: [:update]
    end
    resources :temp_profiles, except: [:show]
  end
  get  '/activate' => 'devices#start_activate'
  post '/activate' => 'devices#activate'

  namespace 'admin' do
    resources :firmware, only: [:index, :create, :destroy, :new] do
      get 'serve', on: :member
    end

    resources :devices, only: :index
  end
  
  namespace :api do
    namespace :v1 do
      resources :devices do
        resources :activation, only: [ :new ]
        resources :auth, only: [ :new ]
        resources :device_report, path: :reports, as: :reports, only: [ :create ]
      end
    end
  end
end
