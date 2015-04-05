require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
  end
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: :show
  
  resources :adverts do
    resources :steps, only: [:show, :update], controller: 'adverts/steps'
    put 'activate', on: :member
    resources :reservations do
      get 'preview_validate', on: :member
      get 'preview_cancel', on: :member
      get 'pending', on: :collection
      put 'validate', on: :member
    end
    resources :pictures, except: :destroy
  end
  resources :pictures, only: :destroy
  resources :evaluations
  resources :charges
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'
  
  get '/' => 'pages#index'
  get 'faq' => 'pages#faq'
  get 'cgu' => 'pages#cgu'
  get 'help' => 'pages#help'
  get 'pending_signup' => 'pages#pending_signup'
  post 'contact_user' => 'pages#contact_user'
  post 'contact_announcer' => 'pages#contact_announcer'

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
