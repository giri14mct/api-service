class User < ApplicationRecord
  has_secure_password

  default_scope { order(last_logged_in: :desc) }

  validates :email, format: { with: EMAIL_REGEX }, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :comments
  enum status: {
    inactive: 0,
    active: 1
  }

  enum role: {
    user: 0,
    admin: 1,
    super_admin: 2
  }

  before_save do
    self.role ||= :user
    self.status ||= :active
  end

  def object_json
    as_json(
      except: %i[password_digest session_token created_at updated_at]
    )
  end

  def self.search_data
    [all.map(&:object_json), count]
  end
end
