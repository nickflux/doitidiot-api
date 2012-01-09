class Todo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :what_to_do,  :type => String
  field :anger_level, :type => Integer, :default => 1
  field :ordinal,     :type => Integer
  field :complete,    :type => Boolean, :default => false
  field :deleted,     :type => Boolean, :default => false

  attr_accessible :what_to_do, :anger_level, :ordinal

  validates_presence_of :what_to_do
  validates_length_of :what_to_do, :within => 1..100, :message => 'is too long'

  scope :alive, :where => { :complete => false, :deleted => false }
  scope :completed, :where => { :complete => true, :deleted => false }

  before_create :add_ordinal

  # formatter for JSON output
  def for_mustache
    {"anger_level" => anger_level, "complete" => complete, "deleted" => deleted, "ordinal" => ordinal, "updated_at" => updated_at.strftime("%Y-%m-%d %H:%M:%S"), "what_to_do" => what_to_do}
  end

  protected

    def add_ordinal
      user_todos      = user.todos.alive.order_by(:ordinal.desc)
      last_ordinal    = user_todos.count > 0 ? user_todos.first.ordinal : 0
      self[:ordinal]  = last_ordinal + 1
    end

end