class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Enum ##
  enum role: %w( admin member )

  ## Associations ##
  has_many :authentication_tokens, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :assignee_lists, class_name: 'ListAssignee', dependent: :destroy
  has_many :assigned_lists, through: :assignee_lists, source: 'list'
  has_many :cards, dependent: :destroy

  ## Validations ##
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  ## Class Methods ##
  def self.invalid_credentials
    'Username or Password is not valid'
  end

  def self.authenticate_user_with_auth(email, password)
    return nil unless email.present? || password.present?
    u = User.find_by_email(email) || User.find_by(username: email)
    (u.present? && u.valid_password?(password)) ? u : nil
  end
end
