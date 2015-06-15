Rails.application.routes.draw do
  root to: 'forms#meet_and_greet'

  resources :forms, only: [:index, :show] do
    collection do
      get :meet_and_greet
    end
    member do
      post :submit
    end
  end
end
