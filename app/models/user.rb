class User < ApplicationRecord
  before_save :downcase_email

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  private

  def downcase_email
    self.email = email.try(:downcase)
  end
end
