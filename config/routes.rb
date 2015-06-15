Rails.application.routes.draw do
  root to: 'forms#show', id: Form.first.id

  resources :forms, only: [:index, :show] do
    member do
      post :submit
    end
  end
end
