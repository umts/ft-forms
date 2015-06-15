Rails.application.routes.draw do
  root to: 'forms#show', id: 1

  resources :forms, only: [:index, :show] do
    member do
      post :submit
    end
  end
end
