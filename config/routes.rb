require 'api_versions'

Rails.application.routes.draw do

  devise_for :users
  namespace :api, defaults: { format: :json }, path: '/' do
    scope module: :v1, constraints: ApiVersions.new(version: 1, default: true) do
      resources :users do
        resources :tasks, only: [:create, :update, :destroy]
      end
      resources :tasks, only: [:index, :show]
      resources :companies
      resources :sessions, only: [:create, :destroy]
    end
  end
end
