class FinishSignupController < ApplicationController
  skip_authorization_check

  def new
    respond_with(@user = User.new)
  end

  def create
    respond_with(@user = User.find_for_oauth(load_auth), location: -> { new_user_confirmation_path })
  end

  private

  def user_params
    params.require(:user).permit([:email, :password, :password_confirmation, :provider, :uid])
  end

  def load_auth
    auth = session['oauth_hash']
    auth['info'] = user_params.slice(:email, :password, :password_confirmation)
    auth
  end
end
