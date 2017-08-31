require 'rails_helper'

RSpec.describe 'Order pages', type: :feature do
  subject { page }

  describe ' when visit Menu page' do
    let(:weekday) { to_weekday Date.today }
    let(:user) { FactoryGirl.create(:user) }
    before do
      10.times { FactoryGirl.create(:course) }
      Course.find_each do |c|
        c.weekday_menus.create(weekday: weekday)
      end
      visit menu_path weekday
    end

    describe ' as unauthorized user' do
      it { should have_title(full_title 'Log in') }
    end

    describe ' as authorized user' do
      before { user_sign_in user }

      describe ' with invalid weekday' do
        before { visit menu_path 'sunday' }

        it { should have_title(full_title 'Home') }
        it { should have_css('div.alert.alert-dismissible.alert-danger',
                             text: 'Invalid weekday.') }
      end

      describe ' with valid weekday' do
        before do
          visit menu_path weekday
        end

        it { should have_title(full_title 'Menu') }
        it ' should have selected courses' do
          Course.menu(weekday).find_each do |course|
            expect(page).to have_content(course.title)
          end
        end
        it ' courses should contain fields' do
          course = Course.menu(weekday).first

          expect(page).to have_css('h4.list-group-item-heading',
                                          text: course.title)
          expect(page).to have_css('p.list-group-item-text',
                                   text: "Price: #{course.price}$")
        end

        describe ' and send form' do
          describe ' without data' do
            before { click_button 'Order' }

            it { should have_title(full_title 'Menu') }
            it { should have_css('div.alert.alert-dismissible.alert-danger',
                                 text: 'Your should choose available courses from all group.') }
          end
        end
      end
    end
  end
end