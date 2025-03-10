Rails.application.routes.draw do
  resources :reports, only: :index
  namespace :reports do
    resources :project_reports, only: [:new, :create, :index]
    resources :personal_reports, only: [:new, :create, :index]
    resources :comprehensive_reports, only: [:new, :create, :index]

    get 'personal_reports_csv/:start_date/:end_date/:users' => 'personal_reports#csv', as: 'personal_reports_csv'
    get 'project_reports_csv/:start_date/:end_date/:projects' => 'project_reports#csv', as: 'project_reports_csv'
    get 'comprehensive_reports_csv/:start_date/:end_date/:projects/:users' => 'comprehensive_reports#csv', as: 'comprehensive_reports_csv'
    get 'matrix_reports_csv/:start_date/:end_date/:projects/:users' => 'comprehensive_reports#csv_matrix', as: 'matrix_reports_csv'
  end

  get    'login' => 'sessions#new'
  post   'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :sessions, only: [:new, :create]
  resources :password_recoveries, only: [:index, :new, :create, :edit, :update]
  resources :logs, only: [:create, :edit, :update, :show, :destroy] do
    patch :save_draft, on: :member
  end
  resources :projects, only: [:index, :new, :create, :edit, :update]
  resources :tags, only: [:new, :create, :edit, :update]
  resources :users, only: [:new, :create, :index, :edit, :update, :show] do
    resource :deactivate, only: [:update]
    get 'activate' => 'activates#update'
    resource :password, only: [:edit, :update]
  end
  resources :imports, only: [:new, :create]
  resources :log_imports, only: [:new, :create]
  get 'settings' => 'settings#index'
  patch 'settings' => 'settings#update'
  get 'admin_dashboard' => 'admin_dashboard#index'
  root 'dashboard#index'
  post '/', to: 'dashboard#create'
  match '*a', to: 'application#not_found', via: :get
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
