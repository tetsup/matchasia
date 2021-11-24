Rails.application.routes.draw do
  devise_for :admins
  devise_for :students, controllers: {
    registrations: 'students/registrations',
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resources :students, only: [] do
    collection do
      get :new_tickets
      post :add_tickets
    end
  end
end
