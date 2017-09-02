Rails.application.routes.draw do
  namespace :admin do
    root to: 'users#index'

    get '/orders/calendar', to: 'orders#calendar', as: 'calendar'

    resources :users,   only: [:index]
    resources :courses, except: [:destroy]
    resources :orders,  only: [:index]
  end

  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions:      'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static_pages#home'

  get '/home',          to: 'static_pages#home', as: 'home'
  get '/menu/:weekday', to: 'orders#new',        as: 'menu'
  resources :orders, only: [:new, :create]
end
