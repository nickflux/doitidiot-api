class IdiotsController < ApplicationController
  respond_to :html, :json
  
  before_filter :authenticate_user!, :get_idiot
  
  def show
    # handle GoCardless response
    if params[:resource_uri]
      @user = current_user
      begin
        GoCardless.confirm_resource(params)
        @user.update_attributes(:gocardless => params)
      rescue => exception
        @user.update_attributes(:gocardless => [exception.message])
      end
    end
    
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