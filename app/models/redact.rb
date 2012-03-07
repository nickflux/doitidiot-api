class Redact
  include Mongoid::Document

  field :code_name,     :type => String
  field :redact_array,  :type => Array

  attr_reader :redact_array
  
  # sort this randomly to change local versions
  def redact_array
    self[:redact_array].shuffle
  end
  
end