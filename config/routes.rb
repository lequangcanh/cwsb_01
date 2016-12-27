Rails.application.routes.draw do

  post "/hook" => "paypals#update"

  resource :store_bookings, only: [:show, :update]

  resources :paypals
  resources :booking_histories, only: :index
  resources :order_histories, only: :index
  resources :static_pages, only: :index
  resource :confirm_payment_directlies
  resource :confirm_payment_bankings

  namespace :search do
    resources :spaces
    root to: "spaces#index"
  end

  root "static_pages#index"
  devise_for :admins
  devise_for :users
  resources :bookings
  resources :venues do
    resources :user_role_venues
    resources :spaces do
      resources :prices
    end
    resources :orders do
      resources :user_payment_directlies
      resources :user_payment_bankings
    end
    resource :venue_detail
    resources :venue_amenities
    resources :amenities do
      resources :service_charges
    end
    resource :venue_market
    resources :payment_methods
    resources :bankings
    resources :directlies
  end

  resources :static_pages
  resources :notifications, only: [:index, :update]
  resources :reads, only: :update do
    post :'update', on: :collection
  end

  mount ActionCable.server => '/cable'
end
