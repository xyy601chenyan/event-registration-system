Rails.application.routes.draw do

  devise_for :users

  root "events#index"
  resources :events

  namespace :admin do
    root "events#index"
    resources :events do
      resources :tickets, controller: "event_tickets"
    end
    resources :categories
    resources :users do
      resource :profile, controller: "user_profiles"
    end
  end

  get "/faq" => "pages#faq"

  resource :user

end
