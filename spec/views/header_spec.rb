require 'rails_helper'

RSpec.describe 'Header', type: :feature do
  subject { page }

  describe ' when visit any page' do
    before { visit root_path }

    it { should have_link('Lunch Ordering', href: root_path) }
    it { should have_link('Home', href: root_path) }

    describe ' as unauthorized user' do
      it { should have_link('Log in', href: new_user_session_path) }
      it { should have_link('Sign up', href: new_user_registration_path) }
      it { should_not have_link('Log out') }
      it { should_not have_link('Admin panel') }
    end

    describe ' as authorized user' do
      before do
        @admin = FactoryGirl.create(:user, email: 'first@mail.com')
        @user = FactoryGirl.create(:user, email: 'second@mail.com')
        user_sign_in @user
      end

      it { should have_css('a.dropdown-toggle', text: "#{@user.name}") }
      it { should have_link('Log out', href: destroy_user_session_path) }
      it { should_not have_link('Log in') }
      it { should_not have_link('Sign up') }
      it { should_not have_link('Admin panel') }

      describe ' with admit roots' do
        before do
          click_link 'Log out'
          user_sign_in @admin
        end

        it { should have_link('Admin panel') }
      end
    end
  end
end