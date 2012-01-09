class TodosController < InheritedResources::Base
  respond_to :html, :json
  
  before_filter :authenticate_user!
  before_filter :get_new_todo
  
  def index
    @todos  = [] unless user_signed_in?
    index!
  end
  
  def create
    create! do |format|
      format.html
      format.json { render json: @todo.for_mustache }
    end
  end
  
  
  protected
    def begin_of_association_chain
      current_user
    end
    
    def collection
      @todos ||= end_of_association_chain.alive
    end
  
    def get_new_todo
      @new_todo = Todo.new
    end
  
end