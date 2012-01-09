class User
  include Mongoid::Document
  include Geocoder::Model::Mongoid  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  :recoverable, :rememberable, :trackable, :validatable, :confirmable, :trackable

  field :email_suffix,  :type => String
  field :coordinates,   :type => Array
  field :address,       :type => String

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

end
