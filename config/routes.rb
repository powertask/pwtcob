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
  resources :taxpayer_contacts
  resources :histories
  resources :remittances
  resources :bank_billets
  resources :discharges

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
  get 'contract/:contract/delete_contract' => 'contracts#delete_contract', as: :delete_contract
  get 'contract/:cod/contract_pdf' => 'contracts#contract_pdf', as: :contract_pdf
  get 'contract/:cod/contract_transaction_pdf' => 'contracts#contract_transaction_pdf', as: :contract_transaction_pdf
  get 'contract/:cod/create_bank_billet' => 'contracts#create_bank_billet', as: :create_bank_billet
  post 'remittance/remittance_create' => 'remittances#remittance_create', as: :remittance_create
  get 'remittance/remittance_new' => 'remittances#remittance_new', as: :remittance_new
  get 'remittance/:cod/remittance_download' => 'remittances#remittance_download', as: :remittance_download
  get 'bank_billet/:cod/bank_billet_show' => 'bank_billets#bank_billet_show', as: :bank_billet_show
  get 'bank_billet/:cod/bank_billet_cancel' => 'bank_billets#bank_billet_cancel', as: :bank_billet_cancel
  get 'discharge/sent_discharge' => 'discharges#sent_discharge', as: :sent_discharge
  post 'discharge/create_discharge' => 'discharges#create_discharge', as: :create_discharge
  
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
