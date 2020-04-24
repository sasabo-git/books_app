# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /ja|en/ do
    resources :books
  end
end
