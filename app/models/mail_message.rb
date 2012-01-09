class MailMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message,         :type => String
  field :message_no_html, :type => String
  field :date_to_send,    :type => Date
  
  validates_presence_of :message, :message_no_html, :date_to_send

end