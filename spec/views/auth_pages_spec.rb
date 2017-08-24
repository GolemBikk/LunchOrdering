require 'rails_helper'

RSpec.describe 'AuthenticationPages', type: :feature do
  subject { page }

  describe 'when sign in' do
    before { visit new_user_session_path }

    describe 'without data' do
      before do
        click_button 'Log in'
      end

      it { should have_css('div.alert.alert-dismissible.alert-info',
                           text: 'Invalid Email or password.') }
    end

    describe 'with invalid data' do
      let(:invalid_email) { 'user@foo.COM' }
      let(:invalid_password) { '654321' }

      before do
        fill_in 'Email',    with: invalid_email
        fill_in 'Password', with: invalid_password
        click_button 'Log in'
      end

      it { should have_css('div.alert.alert-dismissible.alert-info',
                           text: 'Invalid Email or password.') }
    end

    describe 'with valid data' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in 'Email',    with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end

      it { should_not have_css('div.alert.alert-dismissible.alert-info',
                           text: 'Invalid Email or password.') }
    end
  end

  describe 'when sign up' do
    before { visit new_user_registration_path }

    describe 'without data' do
      before do
        click_button 'Sign up'
      end

      it { should have_css('span.help-block', count: 3) }
      it { should have_css('div.alert.alert-dismissible.alert-danger',
                           text: 'Please review the problems below.') }
    end

    describe 'with invalid data' do
      let(:invalid_name) { 'PeterPetersen' }
      let(:invalid_email) { 'user@foo,com' }
      let(:invalid_password) { '54321' }
      let(:invalid_password_confirmation) { '12345' }

      before do
        fill_in 'User name',             with: invalid_email
        fill_in 'Email',                 with: invalid_email
        fill_in 'Password',              with: invalid_password
        fill_in 'Password confirmation', with: invalid_password_confirmation
        click_button 'Sign up'
      end

      it { should have_css('span.help-block', text: 'is invalid', count: 2) }
      it { should have_css('span.help-block', text: /is too short/i) }
      it { should have_css('span.help-block', text: "doesn't match Password") }
      it { should have_css('div.alert.alert-dismissible.alert-danger',
                           text: 'Please review the problems below.') }
    end

    describe 'with valid data' do
      let(:user) { User.new(name: 'Peter Petersen', email: 'user@example.com',
                            password: '123456', password_confirmation: '123456') }

      before do
        fill_in 'User name',             with: user.name
        fill_in 'Email',                 with: user.email
        fill_in 'Password',              with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Sign up'
      end

      it { should_not have_css('span.help-block') }
      it { should_not have_css('div.alert.alert-dismissible.alert-danger',
                               text: 'Please review the problems below.') }
    end
  end
end