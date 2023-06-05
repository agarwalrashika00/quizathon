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

    resources :quizzes, param: :slug do
      member do 
        patch 'activate'
        patch 'inactivate'
      end
    end
  end

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit', as: 'edit_user'
  put '/profile/edit', to: 'users#update'

end
