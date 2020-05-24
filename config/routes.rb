# frozen_string_literal: true

Rails.application.routes.draw do
  root "top#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  scope "(:locale)", locale: /ja|en/ do
    resources :users, only: [:show, :following, :followers] do
      member { get :following, :followers }
    end
    resources :relationships, only: [:create, :destroy]

    resources :books do
      resources :comments, only: [:create, :edit, :destroy, :update], module: :books
    end

    resources :reports do
      resources :comments, only: [:create, :edit, :destroy, :update], module: :reports
    end
  end
end
