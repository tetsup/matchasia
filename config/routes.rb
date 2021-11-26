Rails.application.routes.draw do
  devise_for :admins
  devise_for :teachers, controllers: {
    registrations: 'teachers/registrations',
  }
  devise_for :students, controllers: {
    registrations: 'students/registrations',
  }
  root to: 'home#index'
  namespace :students do
    resource :tickets, only: [:new, :create]
  end
end
