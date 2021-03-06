Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Omniauth Login Route
  get "/auth/github", as: "github_login"

  #Omniauth Github callback route
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"

  delete "/logout", to: "users#logout", as: "logout"


  root "works#root"

  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"

  # get "/users/current", to: "users#current", as: "current_user"
  # get "/users/create", to: "users#create", as: "create_user"

  resources :works
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"

  resources :users, only: [:index, :show, :destroy]
end
