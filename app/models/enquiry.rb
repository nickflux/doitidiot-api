class Enquiry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email,  :type => String
  field :message,    :type => String
  field :enquiry_group, :type => String
  
  validates_presence_of :email, :message
  validates_format_of :email, :with => /^.+@.+\..+$/

end
