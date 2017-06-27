Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :units
  resources :clients
  resources :taxpayers
  resources :categories
  resources :lawyers
  resources :contracts
  resources :proposals
  resources :proposal_tickets
  resources :cnas
  resources :cities
  resources :taxpayer_contacts
  resources :histories
  resources :remittances
  resources :bank_billets
  resources :discharges
  resources :users
  resources :words
  resources :tickets

  resources :user, :controller => 'users'

  resources :home do
    collection do
      get 'filter_name' => 'home#filter_name'
      get :get_tasks
      get :get_click
    end
  end

  get 'get_client' => 'clients#get_client'
  get 'set_client' => 'clients#set_client'


  get 'home/:cod/show' => 'home#show', as: :show
  get 'home/:cod/deal' => 'home#deal', as: :deal
  get 'home/:cod/get_cna' => 'home#get_cna', as: :get_cna
  patch 'home/:cod/pay_cna' => 'home#pay_cna', as: :pay_cna
  patch 'home/:cod/set_cna_to_normal' => 'home#set_cna_to_normal', as: :set_cna_to_normal
  patch 'home/:cod/set_cna' => 'home#set_cna', as: :set_cna
  get 'home/:cod/set_charge_cna' => 'home#set_charge_cna', as: :set_charge_cna
  get 'home/:cod/get_tickets' => 'home#get_tickets', as: :get_tickets
  get 'home/:cod/set_tickets' => 'home#set_tickets', as: :set_tickets
  get 'home/:cod/get_taxpayer' => 'home#get_taxpayer', as: :get_taxpayer
  patch 'home/:cod/set_taxpayer' => 'home#set_taxpayer', as: :set_taxpayer
  get 'home/:cod/set_lawyer_to_cna' => 'home#set_lawyer_to_cna', as: :set_lawyer_to_cna


  post 'proposal/:cod/create_proposal' => 'proposals#create_proposal', as: :create_proposal


  post 'contract/:cod/create_contract_from_proposal' => 'contracts#create_contract_from_proposal', as: :create_contract_from_proposal
  post 'contract/:cod/create_contract' => 'contracts#create_contract', as: :create_contract
  get 'contract/:contract/delete_contract' => 'contracts#delete_contract', as: :delete_contract
  get 'contract/:cod/contract_pdf' => 'contracts#contract_pdf', as: :contract_pdf
  get 'contract/:cod/contract_transaction_pdf' => 'contracts#contract_transaction_pdf', as: :contract_transaction_pdf
  get 'contract/:cod/create_bank_billet' => 'contracts#create_bank_billet', as: :create_bank_billet

  get 'ticket/:cod/create_new_expire_at' => 'tickets#create_new_expire_at', as: :create_new_expire_at
  get 'ticket/:cod/update_status_ticket' => 'tickets#update_status_ticket', as: :update_status_ticket
  
  post 'remittance/remittance_create' => 'remittances#remittance_create', as: :remittance_create
  get 'remittance/remittance_new' => 'remittances#remittance_new', as: :remittance_new
  get 'remittance/:cod/remittance_download' => 'remittances#remittance_download', as: :remittance_download
  get 'bank_billet/:cod/bank_billet_show' => 'bank_billets#bank_billet_show', as: :bank_billet_show
  get 'bank_billet/:cod/bank_billet_cancel' => 'bank_billets#bank_billet_cancel', as: :bank_billet_cancel
  get 'discharge/sent_discharge' => 'discharges#sent_discharge', as: :sent_discharge
  post 'discharge/create_discharge' => 'discharges#create_discharge', as: :create_discharge

  get 'contract/report_payment_filter' => 'contracts#report_payment_filter', as: :report_payment_filter
  get 'contract/report_payment_action' => 'contracts#report_payment_action', as: :report_payment_action
  get 'contract/report_payment_action_pdf' => 'contracts#report_payment_action_pdf', as: :report_payment_action_pdf

  get 'contract/report_fee_filter' => 'contracts#report_fee_filter', as: :report_fee_filter
  get 'contract/report_fee_action' => 'contracts#report_fee_action', as: :report_fee_action
  
  get 'history/report_count_contacts_filter' => 'histories#report_count_contacts_filter', as: :report_count_contacts_filter
  get 'history/report_count_contacts_action' => 'histories#report_count_contacts_action', as: :report_count_contacts_action

  get 'cna/report_cna_lawyer_filter' => 'cnas#report_cna_lawyer_filter', as: :report_cna_lawyer_filter
  get 'cna/report_cna_lawyer_rel' => 'cnas#report_cna_lawyer_rel', as: :report_cna_lawyer_rel

end
