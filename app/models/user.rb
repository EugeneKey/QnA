# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  admin                  :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :skip_confirmation!

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable, omniauth_providers:
             [:facebook, :twitter]

  has_many :comments, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = authorization_user(auth)
    return authorization.user if authorization

    return unless auth['info'][:email].present?

    user = find_user(auth['info']) || generate_user(auth['info'])

    skip_confirm(user) if auth['provider'] == 'twitter'
    user.create_authorization(auth)
    user
  end

  def self.authorization_user(auth)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    authorization
  end

  def self.find_user(auth_info)
    user = User.where(email: auth_info[:email]).first
    user
  end

  def self.skip_confirm(user)
    user.confirmed_at = nil
    user.send_confirmation_instructions
  end

  def create_authorization(auth)
    authorizations.create(provider: auth['provider'], uid: auth['uid'])
  end

  def self.generate_user(auth_info)
    auth_info = generate_password(auth_info) unless auth_info[:password]
    user = User.create!(email: auth_info[:email], password: auth_info[:password], password_confirmation: auth_info[:password_confirmation])
    user
  end

  def self.generate_password(auth_info)
    auth_info[:password], auth_info[:password_confirmation] = Devise.friendly_token[0, 20]
    auth_info
  end

  def subscribed?(question)
    Subscription.exists?(user: self, question: question)
  end
end
