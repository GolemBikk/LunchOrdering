Rails.application.routes.draw do
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions:      'users/sessions',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root to: 'static_pages#home'

  get '/home',          to: 'static_pages#home', as: 'home'
  get '/menu/:weekday', to: 'orders#new',        as: 'menu'

  resources :orders, only: [:new, :create]

  namespace :admin do
    root to: 'users#index'

    get '/orders/calendar', to: 'orders#calendar', as: 'calendar'

    resources :users,   only: [:index]
    resources :courses, except: [:destroy]
    resources :orders,  only: [:index]
  end

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
          registrations: 'api/v1/registrations',
          sessions: 'api/v1/sessions'
      }

      resources :orders,  only: [:index]
    end
  end
end
