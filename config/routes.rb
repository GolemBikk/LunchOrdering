Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index]
    resources :courses, except: [:destroy]

    root to: 'users#index'
  end

  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static_pages#home'

  get '/home', to: 'static_pages#home', as: 'home'
  get '/menu/:weekday', to: 'orders#new', as: 'menu'
  resources :orders, only: [:new, :create]
end
