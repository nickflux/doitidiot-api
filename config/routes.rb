DoitidiotApi::Application.routes.draw do
  
  devise_for :users
  
  resources :todos do
    collection do
      post  :sort
      get   :completed
    end
  end
  resources :enquiries, :only => [:new, :create]
  
  #match 'releases/:id/preview' => 'releases#preview', :as => :preview_release
  
  root :to => "todos#index"
  
end
