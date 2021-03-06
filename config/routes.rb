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
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
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
<<<<<<< HEAD
=======

>>>>>>> texel
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
