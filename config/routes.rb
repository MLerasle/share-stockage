Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/my_admin_zone', as: 'rails_admin'

  devise_for :users, path: :'mon-compte', controllers: { registrations: 'registrations', omniauth_callbacks: "users/omniauth_callbacks", confirmations: 'users/confirmations', passwords: 'users/passwords' }
  resource :users, path: :'mon-compte' do
    member do
      get 'owner_space', path: :'espace-proprietaire'
      get 'lodger_space', path: :'espace-locataire'
    end
    get 'pending_password', on: :collection
  end

  get '/users/sign_in', to: redirect('/mon-compte/sign_in')
  get '/users/sign_up', to: redirect('/mon-compte/sign_up')
  get '/users/password/new', to: redirect('/mon-compte/password/new')
  get '/users/pending_password', to: redirect('/mon-compte/pending_password')
  
  resources :adverts, path: :'garde-meuble' do
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
        put 'cancel'
        get 'payment'
      end
      get 'pending', on: :collection
    end
    resources :pictures, except: :destroy
  end

  get '/adverts/:id', to: redirect('/garde-meuble/%{id}')
  get '/adverts', to: redirect('/garde-meuble')

  resources :pictures, only: :destroy
  resources :evaluations, only: :create
  resources :charges, only: [:new, :create]
  resources :messages, only: [:new, :create]
  resources :payments, only: :create
  resources :articles, path: :blog
  resources :categories, only: :show, path: :'blog-category'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'
  
  get '/' => 'pages#index'
  get 'faq' => 'pages#faq'
  get 'cgu' => 'pages#cgu'
  get 'help' => 'pages#help', path: :aide
  get '/help', to: redirect('/aide')
  get 'welcome' => 'pages#welcome'

  # Landing proprios
  get 'complement-revenu' => 'pages#complement_revenu'
  get 'espace-libre' => 'pages#espace_libre'
  # Landing locataires
  get 'garde-meuble-entre-particuliers' => 'pages#garde_meuble_entre_particuliers'

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
