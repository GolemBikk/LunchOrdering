class User < ApplicationRecord
  VALID_NAME_REGEX = /\A[\w]+ [\w]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+[a-z\d]\.[a-z]+\z/i

  has_many :orders, dependent: :destroy

  validates :name, presence: true,
            format: { with: VALID_NAME_REGEX }

  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  before_create :admin_rule, if: :first_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def first_record?
    User.count.zero?
  end

  private
    def admin_rule
      self.is_admin = true
    end
end
