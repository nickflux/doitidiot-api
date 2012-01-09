require 'spec_helper'

describe Faq do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "validations" do
      
    let(:faq) { FactoryGirl.build(:faq) }
    
    it "should be valid with valid attributes" do
      faq.should be_valid
    end
    
    it "should not be valid without question" do
      faq.question = nil
      faq.should_not be_valid
    end
    
    it "should not be valid without answer" do
      faq.answer = nil
      faq.should_not be_valid
    end
    
    it "should not be valid without faq_group" do
      faq.faq_group = nil
      faq.should_not be_valid
    end
    
  end
  
  describe "add_ordinal" do
    
    it "should set the ordinal to 1 if it's the first for that faq_group" do
      FactoryGirl.create(:faq, :faq_group => "group")
      Faq.where(:faq_group => "group").first.ordinal.should == 1
    end
    
    it "should set the ordinal to 2 if it's the second for that faq_group" do
      lambda do
        FactoryGirl.create(:faq, :faq_group => "group")
        FactoryGirl.create(:faq, :faq_group => "group")
      end.should change{Faq.count}.by(2)
      Faq.where(:faq_group => "group").order_by(:ordinal.asc).first.ordinal.should == 1
      Faq.where(:faq_group => "group").order_by(:ordinal.asc).last.ordinal.should == 2
    end
    
  end
  
end