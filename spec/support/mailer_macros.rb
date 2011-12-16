module MailerMacros
  def emails
    ActionMailer::Base.deliveries
  end

  def last_email
    emails.last
  end
  
  def reset_email
    emails.clear
  end
end
