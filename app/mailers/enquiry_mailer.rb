class EnquiryMailer < ActionMailer::Base
  
  helper :application

  default :from => "no-one-reads-this@doitidiot.com"
  
  def general_enquiry(enquiry)
    @enquiry  = enquiry
    mail(:to => "enquiry@doitidiot.com <enquiry@doitidiot.com>", :subject => "A message for Do It Idiot.")
  end

end