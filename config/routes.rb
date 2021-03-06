Rails.application.routes.draw do
  get 'song_assist/show'

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root 'services#authindex'
  resources :songs
  resources :services
  resources :leaders
  resources :service_types
  resources :usages
  resources :akas#, :path => "alternate_titles" #TODO
  resources :users
  resources :song_tags, only: [:create, :destroy]

  post 'songs/list' => 'songs#list'
  post 'songs/data/:id' => 'songs#data'
  post 'usages/data/:limit' => 'usages#data', :as => 'usage_data'
  post 'leaders/data/:id' => 'leaders#data'
  post 'songassist' => 'song_assist#show'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
