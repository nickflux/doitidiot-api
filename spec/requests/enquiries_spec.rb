require 'spec_helper'

describe "Enquiries" do
    
  describe "Sending a new enquiry" do
        
    it "should create a new enquiry and send an email" do
      lambda do
        visit new_enquiry_path
        fill_in "enquiry_email", :with => "test@example.com"
        fill_in "enquiry_message", :with => "this is the message"
        click_on "Send Enquiry"
        current_path.should == root_path
        last_email.to.should == "enquiry@doitidiot.com <enquiry@doitidiot.com>"
      end.should change{Enquiry.count}.by(1)
    end
        
    it "should not create a new enquiry or send an email" do
      lambda do
        visit new_enquiry_path
        fill_in "enquiry_email", :with => "test"
        fill_in "enquiry_message", :with => "this is the message"
        click_on "Send Enquiry"
        page.should have_content("prohibited this record from being saved")
        last_email.should be_nil
      end.should_not change{Enquiry.count}.by(1)
    end
    
  end

  
end