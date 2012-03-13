class Redact
  include Mongoid::Document

  field :code_name,     :type => String
  field :redact_array,  :type => Array
  field :sweary,        :type => Boolean, :default => false

  attr_reader :redact_array
  
  scope :clean, excludes(sweary: true)
  scope :filthy, where(sweary: true)
  
  
  
  # sort this randomly to change local versions
  def redact_array
    self[:redact_array].shuffle
  end
  
  def redact_array_with_swears
    if swear_redact = ::Redact.where(:sweary => true, :code_name => "#{code_name}-swear").first
      swear_redact.redact_array.shuffle
    else
      redact_array.shuffle
    end
  end
  
end