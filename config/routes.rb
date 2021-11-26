Rails.application.routes.draw do
  devise_for :admins
  devise_for :teachers
  devise_for :students, controllers: {
    registrations: 'students/registrations',
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  namespace :students do
    resource :tickets, only: [:new, :create]
  end
end
