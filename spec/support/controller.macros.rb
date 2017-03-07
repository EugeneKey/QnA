# frozen_string_literal: true
module ControllerMacros
  def sign_in_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  def sign_in_another_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in another_user
    end
  end
end
