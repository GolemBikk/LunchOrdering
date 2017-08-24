require 'rails_helper'

RSpec.describe 'Layouts', type: :feature do
  subject { page }

  describe 'Header' do
    describe 'when visit as unauthorized user' do
      before { visit root_path }

      it { should have_link('Log in', href: new_user_session_path) }
      it { should have_link('Sign up', href: new_user_registration_path) }
      it { should_not have_link('Log out') }
      it { should_not have_link('Admin panel') }
    end

    describe 'when visit as authorized user' do
      before do
        @admin = FactoryGirl.create(:user, email: 'first@mail.com')
        @user = FactoryGirl.create(:user, email: 'second@mail.com')
        visit new_user_session_path
        fill_in 'Email',    with: @user.email
        fill_in 'Password', with: @user.password
        click_button 'Log in'
      end

        it { should have_content("You authorized as #{@user.name}") }
        it { should_not have_link('Log in') }
        it { should_not have_link('Sign up') }
        it { should have_link('Log out', href: destroy_user_session_path) }
        it { should_not have_link('Admin panel') }

        describe 'with admit roots' do
          before do
            click_link 'Log out'
            visit new_user_session_path
            fill_in 'Email',    with: @admin.email
            fill_in 'Password', with: @admin.password
            click_button 'Log in'
          end

          it { should have_link('Admin panel') }
        end
    end
  end
end