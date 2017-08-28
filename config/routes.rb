Rails.application.routes.draw do
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static_pages#home'

  get '/home', to: 'static_pages#home', as: 'home'
  get '/menu/:weekday', to: 'courses#index', as: 'menu'
end
