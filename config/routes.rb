Rails.application.routes.draw do
  root to: 'forms#meet_and_greet'

  resources :forms, only: [:edit, :index, :show] do
    collection do
      get :meet_and_greet
    end
    member do
      get  :preview
      post :submit
      get  :thank_you
    end
  end
end
