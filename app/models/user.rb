class User
  include Mongoid::Document
  include Geocoder::Model::Mongoid  
  
  TIMES_TO_SEND = {"morning" => 6, "noon" => 12, "night" => 20}.freeze
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  :recoverable, :rememberable, :trackable, :validatable, :trackable

  field :email_suffix,  :type => String
  field :coordinates,   :type => Array
  field :address,       :type => String
  field :time_zone,     :type => String
  field :time_to_send,  :type => String

  has_many :todos, :dependent => :destroy

  before_create :generate_disposable_email_suffix
  geocoded_by :last_sign_in_ip
  reverse_geocoded_by :coordinates

  after_validation :geocode

  ###
  # INSTANCE METHODS
  ###

  def generate_disposable_email_suffix
    self.email_suffix  = (0...8).map{65.+(rand(25)).chr}.join
  end
  
  def time_to_send_to_i
    TIMES_TO_SEND[time_to_send]
  end

end
