require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
  end
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: :show do
    member do
      get 'owner_space'
      get 'lodger_space'
    end
  end
  
  resources :adverts do
    resources :steps, only: [:show, :update], controller: 'adverts/steps'
    member do
      put 'activate'
      get 'unavailable_dates'
      get 'preload_pictures'
    end
    resources :reservations do
      member do
        get 'preview_validate'
        get 'preview_cancel'
        put 'validate'
      end
      get 'pending', on: :collection
    end
    resources :pictures, except: :destroy
  end
  resources :pictures, only: :destroy
  resources :evaluations, only: :create
  resources :charges, only: [:new, :create]
  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
    end
    collection do
      delete :empty_trash
    end
  end
  resources :messages, only: [:new, :create]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'
  
  get '/' => 'pages#index'
  get 'faq' => 'pages#faq'
  get 'cgu' => 'pages#cgu'
  get 'help' => 'pages#help'
  get 'pending_signup' => 'pages#pending_signup'

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
