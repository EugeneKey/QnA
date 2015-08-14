class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_oauth

  def facebook
  end

  def twitter
  end

  private

  def sign_in_oauth
    auth = request.env['omniauth.auth'] || session['oauth_hash']
    @user = User.find_for_oauth(auth)
    if  @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth['provider'].capitalize) if is_navigational_format?
    else
      session['oauth_hash'] = auth.slice(:provider, :uid)
      redirect_to finish_signup_path
    end
  end
end
