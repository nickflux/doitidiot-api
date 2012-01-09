class Redact
  include Mongoid::Document

  field :code_name,     :type => String
  field :redact_array,  :type => Array

end