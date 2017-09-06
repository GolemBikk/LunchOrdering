class User < ApplicationRecord
  VALID_NAME_REGEX = /\A[a-zA-Zа-яА-яЁё\-]+ [a-zA-Zа-яА-яЁё\-]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+[a-z\d]\.[a-z]+\z/i

  has_many :orders, dependent: :destroy

  validates :name, presence: true,
            format: { with: VALID_NAME_REGEX }

  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  before_save :ensure_authentication_token!
  before_create :admin_rule, if: :first_record?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def first_record?
    User.count.zero?
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
        user = User.create(name: data['name'], email: data['email'],
                                    password: Devise.friendly_token[0,20])
    end
    user
  end

  private
    def ensure_authentication_token!
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

    def admin_rule
      self.is_admin = true
    end
end
