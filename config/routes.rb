ActionController::Routing::Routes.draw do |map|
  map.resources :people

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.resources :clients
  map.resources :billings
  map.resources :dicts
  map.resources :bookings
  map.resources :bookings, :member => { :bookall => :post }

  map.resources :projects
  map.resources :projects, :member => { :close => :post,
    :approval => :post,
    :disapproval => :post,
    :transform => :post,
    :addcomment => :post 
  }

  map.resources :projects do |project|
    project.resources :bookings
    #project.resources :bookings, :member => { :bookall => :post }
  end
  map.resources :expenses
  map.resources :expenses, :member => { :close => :post,
    :approval => :post,
    :disapproval => :post,
    :addcomment => :post,
    :transform => :post 
  }
  map.get_ot '/personalcharges/get-ot', :controller=>'personalcharges', :action =>'get_ot'
  map.resources :personalcharges
  map.resources :personalcharges, :member=>{:approval=> :post,
    :disapproval=>:post,
    :addcomment => :post,
    :transform => :post
  }
  
  map.resources :periods
  map.root :controller => 'homepage'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  #map.root :controller => 'login', :action => 'login'

end
