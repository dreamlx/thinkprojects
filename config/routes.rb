Thinkprojects::Application.routes.draw do
  devise_for :users

  resources :people
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :admins do
    get :auto_complete_hours, on: :collection
    get :check_ot,            on: :collection
  end
  resources :clients
  resources :billings
  resources :dicts
  resources :bookings do
    post :bookall,            on: :member
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
