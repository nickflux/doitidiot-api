DoitidiotApi::Application.routes.draw do
  offline = Rack::Offline.configure do
    Dir[Rails.root.join("app/assets/stylesheets/*.*")].each do |file|
      cache "assets/" +  File.basename(file).split(".")[0] + ".css"
    end
    cache "assets/jquery.js"
    cache "assets/jquery-ui.js"
    cache "assets/jquery_ujs.js"
    cache "assets/jquery.offline.js"
    cache "assets/json.js"
    cache "assets/mustache.js"
    cache "assets/todos.js"
    cache "assets/application.js"
    
    network "/"
  end
  match "/application.manifest" => offline
  
  devise_for :users
  
  resource  :idiot, :only => [:show, :edit, :update]
  
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
