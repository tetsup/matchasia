Rails.application.routes.draw do
  devise_for :admins
  devise_for :teachers, controllers: {
    registrations: 'teachers/registrations',
    confirmations: 'teachers/confirmations'
  }
  devise_for :students, controllers: {
    registrations: 'students/registrations',
  }
  root to: 'home#index'
  namespace :students do
    resource :tickets, only: [:new, :create]
    resources :lessons, only: [:index] do
      resource :reservation, only: [:create], module: :lessons
    end
    resources :reservations, only: [:index]
  end
  namespace :admins do
    resources :teachers, only: [:index, :destroy] do
      member do
        post :become
      end
    end
  end
  namespace :teachers do
    resources :lessons, only: [:index, :new, :create]
  end
  resources :teachers, only: [:show]
  Rails.env.development? && mount(LetterOpenerWeb::Engine, at: '/letter_opener')
end
