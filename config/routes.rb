Rails.application.routes.draw do
  get 'messages/create'
  get 'messages/destroy'
  devise_for :users
  root to: "pages#home"

  get 'map', to: 'gyms#map', as: :map
  get 'my_account', to: 'users#my_account', as: :my_account
  get 'edit_profile', to: 'users#edit_profile', as: :edit_profile

  get "up" => "rails/health#show", as: :rails_health_check



  get 'users', to: 'users#edit', as: :user_edit

  resources :gyms do
    member do
      get 'chat'
    end
    resources :messages, only: [:create, :destroy]
  end




  resources :profiles, only: [:index, :create]
  resources :profile, only: [:index, :create]

  #Funções para página my_account
  resources :users, only: [:edit, :update]
  resources :users do
    get 'my_account', on: :member
  end

  resources :gyms do
    resources :appointments, only: [:new, :create, :show]
  end
end
