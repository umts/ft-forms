Rails.application.routes.draw do
  root to: 'forms#meet_and_greet'

  resources :forms, only: [:edit, :index, :show, :update] do
    collection { get :meet_and_greet }
    member do
      post :add_field
      post :preview
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
