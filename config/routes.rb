Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :movies, only: [:index, :show] do
    resources :schedules do
      resources :reservations, only: [:new]
    end
  end
  resources :reservations, only: [:create]
  get 'sheets' => 'sheets#index'
  get "movies/:id/reservation", to: "movies#reservation", as: "movie_reservation"

  ## 管理画面
  namespace :admin do
    resources :reservations, only: [:index, :new, :create, :edit, :update, :destroy, :show]
    resources :movies do
      resources :schedules, only: [:new, :create]
      get "schedules", to: "movies#schedules", as: "schedules_json"
    end
    resources :schedules, only: [:index, :edit, :update, :destroy] do
      get "unavailable_sheets", to: "schedules#unavailable_sheets", as: "unavailable_sheets_json"
    end
  end
end
