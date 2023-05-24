Rails.application.routes.draw do
  devise_for :users, path: '/', path_names: { edit: :profile }, controllers: {
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
    resources :users
  end
end
