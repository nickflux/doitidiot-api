module UserMacros
  
  # REQUEST SPEC HELPERS
  def request_user
    @request_user ||= FactoryGirl.create(:confirmed_user)
  end
  
  # use for HTML requests (visit / click actions)
  def request_login(user)
    visit new_user_session_path
    within("#user_new") do
      fill_in 'Email', :with => user.email
      fill_in 'Password', :with => user.password
      uncheck 'Remember me'
    end
    click_on('Sign in')
  end
  
  # use for JSON requests (direct get / post)
  def post_login(user)
    post user_session_path, :user => {:email => user.email, :password => user.password, :remember_me => "0"}
  end
  
end