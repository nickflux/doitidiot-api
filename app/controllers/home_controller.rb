class HomeController < ApplicationController
  respond_to :html, :json
  
  before_filter :authenticate_user!, :only => [:home]
  before_filter :get_new_todo
  
  def home
    redirect_to todos_path if user_signed_in?
  end
  
  def terms_and_conditions
  end
  
  def faqs
  end
  
  protected
  
    def get_new_todo
      @new_todo = Todo.new
    end
  
end