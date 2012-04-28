Roomade::Application.routes.draw do
  # authentication routes with devise
  devise_for :users,
  :controllers => { :registrations => "registrations", :sessions => "sessions" }, 
  :path_names => { :sign_in => "signin", :sign_out => "signout", :sign_up => "register" }
  
  devise_scope :user do
    get "users/signin" => "sessions#new", :as => :sign_in 
    get "users/signout" => "sessions#destroy", :as => :sign_out
    
    get "users/signup" => "registrations#new", :as => :sign_up
    post "users/register" => "registrations#create", :as => :register
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  
  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'public#index'
  # match '/home' => 'home#index', :as => :home
  
  resources :review
  resources :authentication
  
  match 'auth/:id/unlink' => 'authentication#destroy', :as => :omniauth_unlink_facebook
  match 'auth/:provider/callback' => 'authentication#create', :as => :omniauth_callback
  
  match '/search_index' => 'search#index', :as => :search_index
  match '/search_apartments' => 'search#search_apartments', :as => :search_apartments
  
  match '/apartment/:id' => 'apartment#show', :as => :show_apartment
  
  match '/profile/edit' => 'user#edit', :as => :edit_profile
  match '/profile/update' => 'user#update', :as => :update_profile
  # See how all your routes lay out with "rake routes"
  
  # Queue
  match '/enqueue/:apartment_id' => 'user#enqueue', :as => :enqueue_apartment
  match '/dequeue/:apartment_id' => 'user#dequeue', :as => :dequeue_apartment
  
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  # match ':shortname' => 'user#show', :as => :users_show
end
