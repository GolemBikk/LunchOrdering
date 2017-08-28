require 'rails_helper'

RSpec.describe 'Course pages', type: :feature do
  subject { page }

  describe ' when visit Menu page' do
    let(:weekday) { 'monday' }
    before { visit menu_path weekday }

    describe ' as unauthorized user' do
      it { should have_title(full_title 'Log in') }
    end

    describe ' as authorized user' do
      before do
        user = FactoryGirl.create(:user)
        user_sign_in user
      end

      describe ' with invalid weekday' do
        before { visit menu_path 'sunday' }

        it { should have_title(full_title 'Home') }
        it { should have_css('div.alert.alert-dismissible.alert-info',
                             text: 'Invalid weekday.') }
      end

      describe ' with valid weekday' do
        before do
          5.times { FactoryGirl.create(:course) }
          Course.find_each do |c|
            c.weekday_menus.create(weekday: weekday)
          end
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
      end
    end
  end
end