Rails.application.routes.draw do
  devise_for :users, path: '/', controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }

  devise_scope :user do
    get '/admin/sign_in' => 'admin/sessions#new'
    post '/admin/sign_in' => 'admin/sessions#create'
    get '/admin/sign_up' => 'admin/registrations#new'
    post '/admin' => 'admin/registrations#create'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#index'

  resources :admin
end
