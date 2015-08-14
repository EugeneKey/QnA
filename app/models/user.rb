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

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return unless email.present?

    user = User.where(email: email).first
    user = generate_user(email) unless user

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  private

  def self.generate_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
    user
  end
end
