Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :zombies
      resources :weapons, only: [:index, :show]
      resources :armors, only: [:index, :show]
    end
  end
end
