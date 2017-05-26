Rails.application.routes.draw do

  if Rails.env.development?
    root 'sessions#dev_login'
  else root to: redirect('/forms/meet-greet-request-form')
  end


  resources :form_drafts, except: [:create, :index] do
    member do
      post :move_field
      post :remove_field
      post :update_form
    end
  end

  resources :forms, only: [:index, :show, :update, :new] do
    member do
      post :submit
      get  :thank_you
    end
  end

  # Editing options
  resources :fields, only: [:edit, :update]

  # Sessions
  unless Rails.env.production?
    get  'sessions/dev_login', to: 'sessions#dev_login', as: :dev_login
    post 'sessions/dev_login', to: 'sessions#dev_login'
  end
  get 'sessions/unauthenticated', to: 'sessions#unauthenticated', as: :unauthenticated_session
  get 'sessions/destroy', to: 'sessions#destroy', as: :destroy_session

end
