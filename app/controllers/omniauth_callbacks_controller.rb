class OmniauthCallbacksController < Devise::OmniauthCallbacksController  
  def facebook
    social_authentication
  end

  def google_oauth2
    social_authentication
  end

  private
  def social_authentication
    @user = User.from_omniauth request.env["omniauth.auth"]
    if @user.persisted?
      sign_in_and_redirect @user
    else
      flash[:danger] = t "users.registrations.new.duplicate_email"
      redirect_to new_user_password_url
    end
  end
end
