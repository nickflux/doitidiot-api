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
  
  describe "generate_disposable_email_suffix" do
    
    let(:user) { FactoryGirl.build(:user) }
    
    it "generates a disposable email suffix before creating" do
      user.email_suffix.should be_nil
      user.save
      user.email_suffix.should match(/\A[A-Z]{8}\z/)
    end
    
  end
  
end