class Faq
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question,  :type => String
  field :answer,    :type => String
  field :faq_group, :type => String
  field :ordinal,   :type => Integer, :default => 1
  field :published, :type => Boolean, :default => false
  
  validates_presence_of :question, :answer, :faq_group

  scope :alive, :where => { :published => true }

  before_create :add_ordinal

  protected
    
    def add_ordinal
      group_faqs      = Faq.where(:faq_group => faq_group).alive.order_by(:ordinal.desc)
      last_ordinal    = group_faqs.count > 0 ? group_faqs.first.ordinal : 0
      self[:ordinal]  = last_ordinal + 1
    end

end
