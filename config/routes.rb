Brewbit::Engine.routes.draw do

  scope 'dashboard' do
    get '/' => 'devices#index'
    get '/devices/activate' => 'devices#start_activate'
    post '/devices/activate' => 'devices#activate'
    resources :devices do
      resources :sensors
      resources :device_sessions, path: :sessions, as: :sessions do
        post :stop_session, on: :member
        get :updates, on: :member
      end
    end
    resources :temp_profiles, except: [:show]
  end
  get  '/activate' => 'devices#start_activate'
  post '/activate' => 'devices#activate'

  namespace :api do
    namespace :v1 do
      resources :devices do
        resources :activation, only: [ :new ]
        resources :auth, only: [ :new ]
        resources :device_report, path: :reports, as: :reports, only: [ :create ]
        resources :controller_settings, only: [ :create ]
        get 'firmware/check.json' => 'firmware#check'
        get 'firmware/show.json' => 'firmware#show'
      end
    end
  end
end
