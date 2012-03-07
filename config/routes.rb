DoitidiotApi::Application.routes.draw do
  offline = Rack::Offline.configure do
    cache "assets/application.css"
    cache "assets/application.js"
    
    network "/"
  end
  match "/application.manifest" => offline
  
  devise_for :users
  
  resource  :idiot, :only => [:show, :edit, :update]
  resources :redacts, :only => [:index]
  
  resources :todos do
    collection do
      post  :sort
      get   :completed
    end
  end
  resources :enquiries, :only => [:new, :create]
  
  #match 'releases/:id/preview' => 'releases#preview', :as => :preview_release
  
  root :to => "home#home"
  
end
