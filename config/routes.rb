Thinkprojects::Application.routes.draw do
  resources :people
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'users#new', :as => :signup
  resources :users
  resource :session
  resources :clients
  resources :billings
  resources :dicts
  resources :bookings
  resources :bookings do
    member do
      post :bookall
    end
  end

  resources :projects
  resources :projects do
    member do
      post :transform
      post :approval
      post :disapproval
      post :close
      post :addcomment
    end
  end

  resources :projects do
    resources :bookings
  end

  resources :expenses
  resources :expenses do
    member do
      post :transform
      post :approval
      post :disapproval
      post :close
      post :addcomment
    end
  end

  match '/personalcharges/get-ot' => 'personalcharges#get_ot', :as => :get_ot
  resources :personalcharges
  resources :personalcharges do
    member do
      post :transform
      post :approval
      post :disapproval
      post :addcomment
    end
  end

  resources :periods
  root :to => 'homepage#index'
  match '/:controller(/:action(/:id))'
end
