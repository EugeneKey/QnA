# frozen_string_literal: true
module FeatureMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_in_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      info: { email: 'test@facebook.com' },
      provider: 'facebook',
      uid: '123456'
    )
  end

  def sign_in_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      info: { email: nil },
      provider: 'twitter',
      uid: '123456'
    )
  end

  def sign_out
    visit root_path
    click_on 'Sign Out'
  end
end

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

module SphinxHelpers
  def index
    ThinkingSphinx::Test.index
    sleep 0.25 until index_finished?
  end

  def index_finished?
    Dir[Rails.root.join(
      ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*'
    )].empty?
  end
end
