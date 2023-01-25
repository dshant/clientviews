require 'sidekiq/web'
require_relative '../webhooks_receiver/app'

Rails.application.routes.draw do
  mount WHA, at: '/wha' if Rails.env.development?
  
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  constraints CanAccessFlipperUI do
    mount Sidekiq::Web => '/sidekiq'
    # mount Flipper::UI.app(FLIPPER) => '/flipper'
    namespace :admin do
      get '/', to: 'admin#info'
    end
    resources :impersonate, only: [:index] do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end
  end

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'dashboard/index'
  get 'billing', to: 'billing#index'
  mount StripeEvent::Engine, at: '/stripe/event'
  post '/events/mux', to: 'events/mux#create', defaults: { format: 'json' }
  post '/events/segment', to: 'events/segment#create', defaults: { format: 'json' }
  # mount Sidekiq::Web, at: '/sidekiq'

  scope :u, constraints: { format: :json } do
    scope :c do
      post 'visits/(:survey_id)', to: 'tracking#visits'
      post 'identify/(:visitor_token)', to: 'tracking#identify'
      post 'events/(:survey_id)', to: 'tracking#events'
    end
  end

  get 'p/:id', as: 'public', to: 'surveys#public'
  get 'p/:id/thanks', as: 'thank_you', to: 'surveys#thanks'
  # post 'surveys/:id/preview', as: 'survey_preview', to: 'surveys#preview'

  resources :surveys, only: %i[edit update new create show destroy] do
    member do
      match 'preview',via: [:get, :post]
    end
    resources :notifications, only: %i[index create], controller: 'surveys/notifications' do
      collection do
        delete :slack_delete
        resources :webhooks, only: [:new, :edit, :create, :update, :destroy], controller: 'surveys/notifications/webhooks', as: 'response_webhooks' do
        end
      end
    end
    resources :responses, only: %i[index], controller: 'surveys/responses'
    resources :visitors, only: %i[index], controller: 'surveys/visitors'
  end
  resources :responses, only: %i[index show update destroy] do
    post 'reply'
    get 'reply/:id', action: 'view_reply', as: 'view_reply'
    post 'reply/:id/respond', action: 'respond', as: 'reply_respond'
  end
  resources :conversations, only: %i[index show destroy]
  resources :visitors, only: %i[index show], path: 'v'
  resources :sites, only: %i[edit update new create]

  namespace :api, constraints: { format: :json } do
    namespace :mobile do
      namespace :user do
        post 'auth'
      end
    end
    namespace :v1 do
      resources :direct_uploads, only: [:create]
      resources :sites, only: [:show]
      resources :surveys, only: [:show] do
        resources :responses, only: %i[create destroy]
      end
      resources :reply, only: %i[show]
      namespace :zapier do
        get 'auth'
        resources :surveys, only: [:index] do
          collection do
            get 'responses'
          end
        end
        resources :subscriptions, only: [:create, :destroy]
      end
    end
  end

  namespace :onboard do
    get 'back/(:destination)', action: 'back', as: 'back'
    get 'basics'
    get 'personal'
    get 'finalize'
    put 'update/(:id)', action: 'update', as: 'update'
  end

  get :embed, to: 'embeds#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'dashboard#index'
end
