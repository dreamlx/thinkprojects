Thinkprojects::Application.routes.draw do
  devise_for :users

  root :to => 'homepage#index'
  resources :periods
  resources :industries
  resources :dicts
  resources :clients
  resources :prj_expense_logs
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :admins do
    get :auto_complete_hours, on: :collection
    get :check_ot,            on: :collection
  end
  resources :billings do
    resources :receive_amounts, only: [:edit, :create, :update, :destroy]
  end
  resources :projects do
    post :transform, on: :member
    post :approval, on: :member
    post :disapproval, on: :member
    post :close, on: :member
    post :addcomment, on: :member
    resources :bookings do
      post :bookall,            on: :collection
    end
  end
  resources :expenses do
    post :transform, on: :member
    post :approval, on: :member
    post :disapproval, on: :member
    post :close, on: :member
    post :addcomment, on: :member
  end
  resources :personalcharges do
    post :transform, on: :member
    post :approval, on: :member
    post :disapproval, on: :member
    post :addcomment, on: :member
    get :get_ot, on: :collection
  end
end