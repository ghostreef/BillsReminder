Rails.application.routes.draw do
  root 'application#dashboard'
  get '/dashboard', to: 'application#dashboard', as: 'dashboard'

  patch 'bills/paid', to: 'bills#paid', as: 'paid'
  resources :bills, :accounts

  resources :categories do
    collection do
      get 'trends'
    end
    member do
      get 'graph'
      get 'transactions'
    end
  end

  resources :purposes, except: [:show, :new] do
    collection do
      post 'create_many'
    end
  end

  resources :sources do
    collection do
      post 'update_many'
      post 'create_many'
      post 'clear'
      post 'refresh'
      get 'bubbles'
      post 'guess'
    end
    member do
      get 'transactions'
    end
  end

  resources :transactions do
    collection do
      post 'import'
      post 'parse'
      get 'breakdown'
      get 'unknown'
      get 'search'
    end
  end

  resources :transformations do
    collection do
      post 'update_many'
      post 'create_many'
    end
  end

  resources :parsers do
    member do
      get 'enable'
    end
  end
end
