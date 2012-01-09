require 'spec_helper'

describe "Todos" do
    
  describe "GET /" do
    
    context "logged out" do
      
      it "Home page should show correct content" do
        FactoryGirl.create(:todo, :what_to_do => "Other Thing")
        visit root_path
        page.should have_content("Welcome to Do It Idiot")
        page.should have_link("log in")
        page.should have_link("register")
        page.should_not have_field("todo[what_to_do]")
        page.should_not have_css('#todos li')
      end
    
      it "Clicking 'log in' link should take user to new_user_session_path" do
        visit root_path
        click_link('log in')
        current_path.should == new_user_session_path
      end
    
      it "Clicking 'register' link should take user to new_user_registration_path" do
        visit root_path
        click_link('register')
        current_path.should == new_user_registration_path
      end
      
    end
    
    context "logged in" do
    
      before(:each) do
        FactoryGirl.create(:todo, :what_to_do => "First Thing", :user => request_user)
        FactoryGirl.create(:todo, :what_to_do => "Second Thing", :user => request_user)
        FactoryGirl.create(:todo, :what_to_do => "Deleted Thing", :deleted => true, :user => request_user)
        FactoryGirl.create(:todo, :what_to_do => "Completed Thing", :complete => true, :user => request_user)
        FactoryGirl.create(:todo, :what_to_do => "Other Thing") # other user's todo
        request_login(request_user)
      end
      
      it "Home page should show correct content" do
        visit root_path
        page.should have_link("log out")
        page.should have_field("todo[what_to_do]")
        page.should_not have_link("log in")
        page.should_not have_link("register")
        page.should have_css('#todos li', :count => 2)
        page.should have_content("First Thing")
        page.should_not have_content("Other Thing")
      end
    
      it "Clicking 'log out' link should take user to destroy_user_session_path" do
        visit root_path
        click_link('log out')
        current_path.should == root_path
        page.should_not have_link("log out")
      end
      
    end
  
  end
  
  describe "Create, Update", :focus do
  
    before(:each) do
      post_login(request_user)
    end
    
    it "POST /todos creates a new to_do and returns object " do
      lambda do
        post "/todos.json", :todo => {:what_to_do => "I must do this"}
      end.should change{request_user.todos.count}.by(1)
      returned_json = Yajl::Parser.parse(response.body)
      returned_json.should == request_user.todos.first.for_mustache
    end
    
    it "POST /todos fails to create a new to_do and returns failure status" do
      lambda do
        post "/todos.json", :todo => {:what_to_do => ""}
      end.should_not change{request_user.todos.count}.by(1)
      d{response.status}
      response.status.should_not == 200
    end
    
    it "PUT /todos updates a todo and returns success" do
      todo  = FactoryGirl.create(:todo, :what_to_do => "First Thing", :user => request_user)
      lambda do
        post "/todos/#{todo.id}.json", :_method => "put", :todo => {:what_to_do => "This has been updated"}
      end.should_not change{request_user.todos.count}.by(1)
      response.status.should == 200
      Todo.where(:user_id => request_user.id).first.what_to_do.should == "This has been updated"
    end
    
    it "PUT /todos fails to update a todo and returns failure status" do
      todo  = FactoryGirl.create(:todo, :what_to_do => "First Thing", :user => request_user)
      lambda do
        post "/todos/#{todo.id}.json", :_method => "put", :todo => {:what_to_do => ""}
      end.should_not change{request_user.todos.count}.by(1)
      response.status.should_not == 200
    end
    
  end
  
end