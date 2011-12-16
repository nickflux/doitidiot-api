module UserMacros
  
  # REQUEST SPEC HELPERS
  def request_user
    @request_user ||= FactoryGirl.create(:confirmed_user)
  end
  
  def request_login(user)
    visit new_user_session_path
    within("#login") do
      fill_in 'Email address', :with => user.email
      fill_in 'Password', :with => user.password
      uncheck 'Remember me'
    end
    click_on('Log in')
  end
  
end