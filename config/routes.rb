Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :units
  resources :clients
  resources :taxpayers
  resources :employees
  resources :categories
  resources :tasks
  resources :lawyers
  resources :contracts
  resources :cnas
  resources :cities
  
  resources :user, :controller => 'users'

  resources :home do
    collection do
      get 'filter_name' => 'home#filter_name'
    end
  end

  get 'home/:cod/show' => 'home#show', as: :show
  get 'home/:cod/deal' => 'home#deal', as: :deal
  get 'home/:cod/get_cna' => 'home#get_cna', as: :get_cna
  patch 'home/:cod/set_cna' => 'home#set_cna', as: :set_cna
  get 'home/:cod/get_tickets' => 'home#get_tickets', as: :get_tickets
  get 'home/:cod/set_tickets' => 'home#set_tickets', as: :set_tickets
  get 'home/:cod/get_taxpayer' => 'home#get_taxpayer', as: :get_taxpayer
  patch 'home/:cod/set_taxpayer' => 'home#set_taxpayer', as: :set_taxpayer
  post 'contract/:cod/create_contract' => 'contracts#create_contract', as: :create_contract
  get 'contract/:cod/contract_pdf' => 'contracts#contract_pdf', as: :contract_pdf

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
