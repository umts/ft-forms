Rails.application.routes.draw do
  resources :forms, only: [:index, :show] do
    member do
      post :submit
    end
  end
end
