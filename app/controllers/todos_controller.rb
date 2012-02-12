class TodosController < InheritedResources::Base
  respond_to :html, :json
  
  before_filter :authenticate_user!
  before_filter :get_new_todo
  
  def index
  end
  
  def create
    create! do |format|
      format.html
      format.json { render json: @todo.for_mustache }
    end
  end
  
  def sort
    params[:todo].each_with_index do |id, index|
      Todo.find(id).update_attributes(ordinal: index+1)
    end
    render nothing: true
  end
  
  def completed
    
  end
  
  protected
    def begin_of_association_chain
      current_user
    end
    
    def collection
      @todos ||= end_of_association_chain.alive.order_by(:ordinal.asc)
    end
  
    def get_new_todo
      @new_todo = Todo.new
    end
  
end