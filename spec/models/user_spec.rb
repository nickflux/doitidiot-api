require 'spec_helper'

describe User do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "validations" do
      
    let(:user) { FactoryGirl.build(:user) }
    
    it "should be valid with valid attributes" do
      user.should be_valid
    end
    
  end
  
end