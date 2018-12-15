Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      ## Registrations
      post    'signup', to: 'registrations#create', as: :signup

      ## Sessions
      post    'login',  to: 'sessions#create',      as: :login
      delete  'logout/:authentication_token', to: 'sessions#destroy',     as: :logout

      ## Users ##
      resources :users, only: [:update, :index], format: :json

      ## Lists ##
      resources :lists do
        post 'assign_member/:member_id', to: 'lists#assign_member', as: :assign_member
        post 'un_assign_member/:member_id', to: 'lists#un_assign_member', as: :un_assign_member
      end

      ## Cards ##
      resources :cards

      ## Comments ##
      resources :comments
    end
  end
end
