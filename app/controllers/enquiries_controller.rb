class EnquiriesController < InheritedResources::Base
  
  respond_to :html, :json
  actions :new, :create
  
  def create
    create! do |success, failure|
      success.html { redirect_to(root_path, :notice => "Your enquiry has been sent") }
      failure.html { render :new }
      success.json { render json: @todo.for_mustache }
    end
  end
  
end