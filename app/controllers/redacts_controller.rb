class RedactsController < ApplicationController
  respond_to :json
  
  def index
    @redacts = Redact.clean
  end
  
end