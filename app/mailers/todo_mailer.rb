class TodoMailer < ActionMailer::Base
  
  helper :application

  default :from => "no-one-reads-this@doitidiot.com"

  def daily_todos(user)
    @user   = user
    @todos  = user.todos.alive.asc(:ordinal)
    @mail_message = MailMessage.where(:date_to_send => Date.today).first
    mail(:to => @user.email, :subject => "Why haven't you done this yet? Do it, #{insult}.")
  end
  
  def insult
    @insult ||= Redact.where(:code_name => 'diswnouns').first.redact_array.first
  end

end
