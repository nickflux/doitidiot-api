require 'spec_helper'

describe Redact do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "validations" do
      
    let(:redact) { FactoryGirl.build(:redact) }
    
    it "should be valid with valid attributes" do
      redact.should be_valid
    end
    
  end
  
end