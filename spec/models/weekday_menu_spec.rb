require 'rails_helper'

RSpec.describe WeekdayMenu, type: :model do
  before do
    @course = FactoryGirl.create(:course)
    @weekday_menu = @course.weekday_menus.build(weekday: 'monday')
  end

  subject { @weekday_menu }

  it { should respond_to(:weekday) }
  it { should respond_to(:course_id) }
  it { should respond_to(:course) }
  it ' should equal' do
    expect(@weekday_menu.course).to eq(@course)
  end
  it { should be_valid }

  describe 'when course_id is not present' do
    before { @weekday_menu.course_id = nil }
    it { should_not be_valid }
  end

  describe ' when weekday is not present' do
    before { @weekday_menu.weekday = ' ' }

    it { should_not be_valid }
  end

  describe ' when weekday is invalid' do
    before { @weekday_menu.weekday = 'sunday' }

    it { should_not be_valid }
  end

  describe ' when weekday is valid' do
    it ' should be valid' do
      weekdays = WeekdayMenu.weekdays
      weekdays.each do |valid_weekday|
        @weekday_menu.weekday = valid_weekday
        expect(@weekday_menu).to be_valid
      end
    end
  end
end
