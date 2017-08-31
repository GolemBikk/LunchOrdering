require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = User.new(name: 'Ivan Ivanov', email: 'user@example.com',
                            password: '123456', password_confirmation: '123456') }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:orders) }
  it { should be_valid }

  describe ' when name is not present' do
    before { @user.name = ' ' }

    it { should_not be_valid }
  end

  describe ' when name format is invalid ' do
    it ' should be invalid' do
      names = ['IvanovIvan', '!vanov Iv@n', 'Ivanov Ivan Ivanovich']
      names.each do |invalid_name|
        @user.name = invalid_name
        expect(@user).not_to be_valid
      end
    end
  end

  describe ' when name format is valid ' do
    before { @user.name = 'Ivanov Ivan' }

    it { should be_valid }
  end

  describe ' when email is not present' do
    before { @user.email = ' ' }

    it { should_not be_valid }
  end

  describe ' when email format is invalid' do
    it ' should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_email|
        @user.email = invalid_email
        expect(@user).not_to be_valid
      end
    end
  end

  describe ' when email format is valid' do
    it ' should be valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_email|
        @user.email = valid_email
        expect(@user).to be_valid
      end
    end
  end

  describe ' when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe ' when password is not present' do
    before { @user.password = @user.password_confirmation = ' ' }

    it { should_not be_valid }
  end

  describe " with a password that's too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }

    it { should be_invalid }
  end

  describe " when password doesn't match confirmation" do
    before { @user.password_confirmation = 'mismatch' }

    it { should_not be_valid }
  end

  describe ' when save first record' do
    before do
      FactoryGirl.create(:user, email: 'first@mail.com')
    end

    it ' should have admin roots' do
      expect(User.find_by_email('first@mail.com').is_admin).to be true
    end
  end

  describe ' when save not first record' do
    before do
      FactoryGirl.create(:user, email: 'first@mail.com')
      FactoryGirl.create(:user, email: 'second@mail.com')
    end

    it " shouldn't have admin roots" do
      expect(User.find_by_email('second@mail.com').is_admin).to be false
    end
  end
end
