class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :load_auth
  before_action :sign_in_oauth

  skip_authorization_check

  def facebook
  end

  def twitter
  end

  private

  def sign_in_oauth
    @user = User.find_for_oauth(@auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth['provider'].capitalize) if is_navigational_format?
    else
      session['oauth_hash'] = @auth.slice(:provider, :uid)
      redirect_to new_finish_signup_path
    end
  end

  def load_auth
    @auth = request.env['omniauth.auth'] || session['oauth_hash']
  end
end
