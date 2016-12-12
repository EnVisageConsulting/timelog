Rails.application.routes.draw do
  resources :reports, only: :index
  namespace :reports do
    resources :payroll_reports, only: [:new, :create]
  end

  get    'login' => 'sessions#new'
  post   'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :sessions, only: [:new, :create]
  resources :password_recoveries, only: [:new, :create, :edit, :update]
  resources :logs, only: [:create, :edit, :update, :show]
  resources :projects, only: [:index, :new, :create, :edit, :update]
  resources :users, only: [:new, :create, :index, :edit, :update] do
    resource :deactivate, only: [:update]
  end
  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
