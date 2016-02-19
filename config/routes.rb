Rails.application.routes.draw do
  root 'bills#dashboard'
  get 'bills/dashboard', to: 'bills#dashboard', as: 'dashboard'
  patch 'bills/paid', to: 'bills#paid', as: 'paid'
  resources :bills

  resources :purposes, except: [:show, :new] do
    collection do
      post 'create_many'
    end
  end

  resources :sources do
    collection do
      post 'update_many'
    end
  end

end
