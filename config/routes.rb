Rails.application.routes.draw do
  resources :reports, only: :index
  namespace :reports do
    resources :invoice_reports, only: [:new, :create, :index]
    resources :payroll_reports, only: [:new, :create, :index]
  end

  get    'login' => 'sessions#new'
  post   'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :sessions, only: [:new, :create]
  resources :password_recoveries, only: [:index, :new, :create, :edit, :update]
  resources :logs, only: [:create, :edit, :update, :show, :destroy]
  resources :projects, only: [:index, :new, :create, :edit, :update]
  resources :users, only: [:new, :create, :index, :edit, :update, :show] do
    resource :deactivate, only: [:update]
    get 'activate' => 'activates#update'
    resource :password, only: [:edit, :update]
  end
  get 'settings' => 'settings#index'
  patch 'settings' => 'settings#update'
  get 'admin_dashboard' => 'admin_dashboard#index'
  root 'dashboard#index'
  match '*a', to: 'application#not_found', via: :get
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
