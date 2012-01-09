require 'spec_helper'

describe MailMessage do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "validations" do
      
    let(:mail_message) { FactoryGirl.build(:mail_message) }
    
    it "should be valid with valid attributes" do
      mail_message.should be_valid
    end
    
    it "should not be valid without message" do
      mail_message.message = nil
      mail_message.should_not be_valid
    end
    
    it "should not be valid without message_no_html" do
      mail_message.message_no_html = nil
      mail_message.should_not be_valid
    end
    
    it "should not be valid without date_to_send" do
      mail_message.date_to_send = nil
      mail_message.should_not be_valid
    end
    
  end
  
end