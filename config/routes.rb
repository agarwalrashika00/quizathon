Rails.application.routes.draw do
  devise_for :users, path: '/', controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    passwords: 'users/passwords'
  }

  devise_scope :user do
    get '/admin/sign_in' => 'admin/sessions#new'
    post '/admin/sign_in' => 'admin/sessions#create'
  end

  # Defines the root path route ("/")
  root 'home#index'

  namespace :admin do
    resources :users do
      member do 
        patch 'block'
        patch 'unblock'
      end
    end

    resources :genres, param: :slug do
      member do 
        patch 'activate'
        patch 'inactivate'
      end
    end

    resources :questions, param: :slug do
      member do
        patch 'activate'
        patch 'inactivate'
      end
    end

  end

  resources :users, only: [:show, :edit, :update], path: '/', path_names: {show: 'profile', edit: 'profile/edit'}
end
