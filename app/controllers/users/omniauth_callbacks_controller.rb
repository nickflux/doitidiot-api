class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def twitter
    # You need to implement the method below in your model
    render :text => request.env["omniauth.auth"].to_yaml
    #@user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
    #
    #if @user.persisted?
    #  flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
    #  sign_in_and_redirect @user, :event => :authentication
    #else
    #  session["devise.twitter_data"] = request.env["omniauth.auth"]
    #  redirect_to new_user_registration_url
    #end
  end
  
  def failure
    render :text => request.env["omniauth.auth"].to_yaml
  end
  
end