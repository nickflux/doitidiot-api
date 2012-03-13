class User
  include Mongoid::Document
  include Geocoder::Model::Mongoid  
  
  TIMES_TO_SEND = {"morning" => 6, "noon" => 12, "night" => 20}.freeze
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  :recoverable, :rememberable, :trackable, :validatable, :trackable, :omniauthable

  field :email_suffix,  :type => String
  field :coordinates,   :type => Array
  field :address,       :type => String
  field :time_zone,     :type => String, :default => "London"
  field :time_to_send,  :type => String, :default => "morning"
  field :provider,      :type => String
  field :provider_name  :type => String
  field :uid,           :type => String
  field :token,         :type => String
  field :secret,        :type => String

  has_many :todos, :dependent => :destroy

  before_create :generate_disposable_email_suffix
  geocoded_by :last_sign_in_ip
  reverse_geocoded_by :coordinates

  after_validation :geocode

  ###
  # CLASS METHODS
  ###
  
  def self.find_for_twitter_oauth(access_token, signed_in_resource = nil)
    uid           = access_token.uid
    provider      = "twitter"
    provider_name = access_token.info.name
    if user = User.where(:uid => uid, :provider => provider).first
      user
    else # Create a user with a stub password.
      User.create!(
        :provider       => provider,
        :provider_name  => provider_name,
        :uid            => uid,
        :token          => access_token.credentials.token,
        :secret         => access_token.credentials.secret,
        :email          => "#{provider_name}@faketwitteremail.com", # to pass validations
        :password       => Devise.friendly_token[0,20] # to pass validations
      ) 
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

  ###
  # INSTANCE METHODS
  ###

  def generate_disposable_email_suffix
    self.email_suffix  = (0...8).map{65.+(rand(25)).chr}.join
  end
  
  def time_to_send_to_i
    TIMES_TO_SEND[time_to_send]
  end
  
  def hash_from_omniauth(omniauth)
    {
      :provider => omniauth['provider'], 
      :uid => omniauth['uid'], 
      :token => (omniauth['credentials']['token'] rescue nil),
      :secret => (omniauth['credentials']['secret'] rescue nil)
    }
  end

end
