Rails.application.routes.draw do
  root 'application#dashboard'
  get '/dashboard', to: 'application#dashboard', as: 'dashboard'

  get 'trends', to: 'categories'
  patch 'bills/paid', to: 'bills#paid', as: 'paid'
  resources :bills, :categories

  resources :purposes, except: [:show, :new] do
    collection do
      post 'create_many'
    end
  end

  resources :sources do
    collection do
      post 'update_many'
      post 'create_many'
    end
  end

  resources :transactions do
    collection do
      post 'import'
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
