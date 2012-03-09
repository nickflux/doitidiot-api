DoitidiotApi::Application.routes.draw do
  offline = Rack::Offline.configure do
    cache "assets/application.css"
    cache "assets/application.js"
    cache "assets/main_logo.gif"
    cache "assets/boggle.png"
    cache ""
    
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
  match 'terms_and_conditions' => 'home#terms_and_conditions', :as => :terms_and_conditions
  match 'faqs' => 'home#faqs', :as => :faqs
  
  root :to => "home#home"
  
end
