Thinkprojects::Application.routes.draw do
  devise_for :users

  resources :people
  resources :users
  resources :clients
  resources :billings
  resources :dicts
  resources :bookings do
    member do
      post :bookall
    end
  end
  resources :projects do
    member do
      post :transform
      post :approval
      post :disapproval
      post :close
      post :addcomment
    end
    resources :bookings
  end
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
  resources :personalcharges do
    member do
      post :transform
      post :approval
      post :disapproval
      post :addcomment
    end
  end

  resources :periods
  resources :industries
  root :to => 'homepage#index'
end
