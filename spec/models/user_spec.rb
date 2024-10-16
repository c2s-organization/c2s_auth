require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'has_secure_password' do
    it 'encrypts the password' do
      user = User.create(email: 'test@example.com', password: 'password123')
      expect(user.authenticate('password123')).to be_truthy
    end

    it 'does not authenticate with an incorrect password' do
      user = User.create(email: 'test@example.com', password: 'password123')
      expect(user.authenticate('wrong_password')).to be_falsey
    end
  end
end
