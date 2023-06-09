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
  root 'quizzes#index'

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
        patch 'feature'
      end
    end

    resources :stats, only: :index

    resources :comments do
      member do
        patch 'publish'
        patch 'unpublish'
      end
    end

    resources :ratings
  end

  resources :quizzes, param: :slug do
    member do
      put 'start'
      get 'resume'
      get 'submit'
      put 'complete'
      post 'comment'
      post 'rate'
      patch 'rate'

      resources :questions, param: :question_slug do
        member do
          put 'submit'
          get 'next'
          get 'previous'
        end
      end

      resources :checkouts, only: :create
    end

    get 'my_quizzes', on: :collection
  end

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit', as: 'edit_user'
  put '/profile/edit', to: 'users#update'

end
