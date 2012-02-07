require 'spec_helper'

describe Todo do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "validations" do
      
    let(:todo) { FactoryGirl.build(:todo) }
    
    it "should be valid with valid attributes" do
      todo.should be_valid
    end
    
    it "should not be valid without what_to_do" do
      todo.what_to_do = nil
      todo.should_not be_valid
    end
    
    it "should not be valid when what_to_do is too long" do
      todo.what_to_do = (0...150).map{97.+(rand(25)).chr}.join
      todo.should_not be_valid
    end
    
  end
  
  describe "add_ordinal" do
      
    let(:user) { FactoryGirl.create(:user) }
    
    it "should set the ordinal to 1 if it's the first for that user" do
      user.todos << FactoryGirl.build(:todo)
      user.todos.first.ordinal.should == 1
    end
    
    it "should set the ordinal to 2 if it's the first for that user" do
      user.todos << FactoryGirl.build(:todo)
      user.todos << FactoryGirl.build(:todo)
      user.todos.last.ordinal.should == 2
    end
    
  end
  
  describe "for_mustache" do
      
    let(:user) { FactoryGirl.create(:user) }
    
    it "should format todo as JSON for mustache" do
      todo  = FactoryGirl.create(:todo, :user => user)
      todo.for_mustache.should == {"anger_level" => todo.anger_level, "complete" => false, "deleted" => false, "ordinal" => 1, "updated_at" => todo.updated_at.strftime("%Y-%m-%d %H:%M:%S"), "what_to_do" => todo.what_to_do}
    end
    
  end
  
end