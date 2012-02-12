class HomeController < ApplicationController
  respond_to :html, :json
  
  before_filter :authenticate_user!, :get_new_todo
  
  def home
  end
  
  protected
  
    def get_new_todo
      @new_todo = Todo.new
    end
  
end