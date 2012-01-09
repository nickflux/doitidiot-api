require 'spec_helper'

describe Enquiry do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "validations" do
      
    let(:enquiry) { FactoryGirl.build(:enquiry) }
    
    it "should be valid with valid attributes" do
      enquiry.should be_valid
    end
    
    it "should not be valid without message" do
      enquiry.message = nil
      enquiry.should_not be_valid
    end
    
    it "should not be valid without email" do
      enquiry.email = nil
      enquiry.should_not be_valid
    end
    
    it "should not be valid with incorrect format for email" do
      enquiry.email = "wrongemail"
      enquiry.should_not be_valid
    end
    
  end
  
end