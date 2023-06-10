Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'publish/sort/:order_by', to: 'publishes#sort_publish'
  get '/search', to: 'publishes#search'

  resources :vehicles
  
  devise_scope :user do
    get '/users', to: 'users/registrations#show', as: :user_profile
    delete '/users', to: 'users/registrations#destroy'
    post '/verify', to: 'authentication#verify'
    post '/phone', to: 'authentication#phone'
    get "givenrating",to:"users/sessions#givenRating"
    get "recievedrating",to:"users/sessions#recievedRating"
    get "showprofile", to:"users/sessions#showprofile"
  
  end
  put '/user_images', to: 'user_images#update'
  get '/user_images', to: 'user_images#show'

  resources :publishes 
  resources :account_activations, only: [:edit,:create]


  post '/book_publish', to: 'passengers#book_publish'
  post '/cancel_publish', to: 'passengers#cancel_publish'

  post '/chats', to: 'chats#create'


  post "/ratings",to:"ratings#ratings"
 
  
end
