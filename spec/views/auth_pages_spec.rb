require 'rails_helper'

RSpec.describe 'Authentication pages', type: :feature do
  subject { page }

  describe ' when visit Sign in page' do
    before { visit new_user_session_path }

    it { should have_title('Log in') }

    describe ' and send form' do
      describe ' without data' do
        before { click_button 'Log in' }

        it { should have_css('div.alert.alert-dismissible.alert-info',
                             text: 'Invalid Email or password.') }
      end

      describe 'with invalid data' do
        before do
          invalid_user = User.new(email: 'user@foo.COM', password: '654321')
          user_sign_in invalid_user
        end

        it { should have_css('div.alert.alert-dismissible.alert-info',
                             text: 'Invalid Email or password.') }
      end
    end
  end

  describe ' when visit Sign up page' do
    before { visit new_user_registration_path }

    it { should have_title('Sign up') }

    describe ' and send form' do
      describe ' without data' do
        before { click_button 'Sign up' }

        it { should have_css('span.help-block', text: "can't be blank", count: 3) }
        it { should have_css('div.alert.alert-dismissible.alert-danger',
                             text: 'Please review the problems below.') }
      end

      describe ' with invalid data' do
        before do
          fill_in 'User name',             with: 'PeterPetersen'
          fill_in 'Email',                 with: 'user@foo,com'
          fill_in 'Password',              with: '54321'
          fill_in 'Password confirmation', with: '12345'
          click_button 'Sign up'
        end

        it { should have_css('span.help-block', text: 'is invalid', count: 2) }
        it { should have_css('span.help-block', text: /is too short/i) }
        it { should have_css('span.help-block', text: "doesn't match Password") }
        it { should have_css('div.alert.alert-dismissible.alert-danger',
                             text: 'Please review the problems below.') }
      end
    end
  end
end