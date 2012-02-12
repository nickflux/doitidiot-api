class IdiotsController < ApplicationController
  respond_to :html, :json
  
  before_filter :authenticate_user!, :get_idiot
  
  def show
  end
  
  def edit
  end
  
  def update
    if @idiot.update_attributes(params[:idiot])
    end
    render :show
  end
  
  protected
    
    def get_idiot
      @idiot  = current_user
    end
  
end