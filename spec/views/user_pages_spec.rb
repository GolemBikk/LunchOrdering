require 'rails_helper'

RSpec.describe 'User pages', type: :feature do
  subject { page }

  describe 'when visit Edit page' do
    before do
      FactoryGirl.create(:user, email: 'first@mail.com', name: 'Ivanko Peterson')
      user = FactoryGirl.create(:user, email: 'example@mail.com', name: 'Peter Peterson')
      user_sign_in user
      visit edit_user_registration_path
    end

    it { should have_title('Edit profile') }
    it { should have_link('Cancel my account', href: user_registration_path) }

    describe ' as admin' do
      before do
        user = User.find_by_email('first@mail.com')
        click_link 'Log out'
        user_sign_in user
        visit edit_user_registration_path
      end

      it { should_not have_link('Cancel my account', href: user_registration_path) }
    end

    describe ' and send form' do
      describe ' without data' do
        before do
          fill_in 'User name',  with: ''
          fill_in 'Email',      with: ''
          click_button 'Update'
        end

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
          fill_in 'Current password',      with: '123456'
          click_button 'Update'
        end

        it { should have_css('span.help-block', text: 'is invalid', count: 3) }
        it { should have_css('span.help-block', text: /is too short/i) }
        it { should have_css('span.help-block', text: "doesn't match Password") }
        it { should have_css('div.alert.alert-dismissible.alert-danger',
                             text: 'Please review the problems below.') }
      end
    end
  end
end