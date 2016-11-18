Rails.application.routes.draw do
  get    'login' => 'sessions#new'
  post   'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :sessions, only: [:new, :create]
  # resources :client_projects
  # resources :client_users
  # resources :clients
  # resources :project_logs
  resources :logs, only: [:create, :edit, :update, :show]
  resources :projects, only: [:index, :new, :create, :edit, :update]
  resources :users, only: [:new, :create, :index, :edit, :update] do
    resource :deactivate, only: [:update]
  end
  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
