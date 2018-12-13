class AuthenticationToken < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :user

  ## Scopes ##
  scope :current_authentication_token_for_user, ->(user_id, token) { joins(:user).where('users.id =? and token = ?', user_id, token) }

  ## Class Methods ##
  def self.generate_unique_token
    token = SecureRandom.hex(20)
    while AuthenticationToken.find_by_token(token)
      token = SecureRandom.hex(20)
    end
    token
  end

  def self.find_user_from_authentication_token(token)
    u = where(token: token)
    (u.present? && u.first.user.present?) ? u.first.user : nil
  end
end
