DoitidiotApi::Application.routes.draw do
  devise_for :users
  
  resources :todos
  
  root :to => "todos#index"
end
