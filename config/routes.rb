Rails.application.routes.draw do
  root to: 'forms#meet_and_greet'

  resources :form_drafts, except: [:create, :index] do
    member do
      post :move_field
      post :remove_field
      post :update_form
    end
  end

  resources :forms, only: [:index, :show, :update] do
    collection do
      get  :meet_and_greet # ROOT
    end
    member do
      post :submit
      get  :thank_you
    end
  end

  resources :sessions, only: [:new] do
    collection do
      get    :dev_login
      post   :dev_login
      delete :destroy
    end
  end
end
