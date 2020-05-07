# frozen_string_literal: true

Rails.application.routes.draw do
  root "top#index"
  get "users/show"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  scope "(:locale)", locale: /ja|en/ do
    resources :books
  end
end
