# frozen_string_literal: true

Rails.application.routes.draw do
  root "top#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:show, :following, :followers] do
    member { get :following, :followers }
  end
  resources :relationships, only: [:create, :destroy]

  scope "(:locale)", locale: /ja|en/ do
    resources :books
  end
end
