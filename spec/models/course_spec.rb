require 'rails_helper'

RSpec.describe Course, type: :model do
  before { @course = Course.new(title: 'Soup', course_type: 'first',
                                price: 30) }

  subject { @course }

  it { should respond_to(:title) }
  it { should respond_to(:course_type) }
  it { should respond_to(:price) }
  it { should respond_to(:weekday_menus) }
  it { should be_valid }

  describe ' when title is not present' do
    before { @course.title = ' ' }

    it { should_not be_valid }
  end

  describe ' when title is too long' do
    before { @course.title = 'a' * 51 }

    it { should_not be_valid }
  end

  describe ' when course_type is not present' do
    before { @course.course_type = ' ' }

    it { should_not be_valid }
  end


  describe ' when course_type is invalid' do
    before { @course.course_type = 'juice' }

    it { should_not be_valid }
  end

  describe ' when course_type is valid' do
    it ' should be valid' do
      types = %w[first main drink]
      types.each do |valid_type|
        @course.course_type = valid_type
        expect(@course).to be_valid
      end
    end
  end

  describe ' when price is not present' do
    before { @course.price = nil }

    it { should_not be_valid }
  end

  describe ' when price has value less than zero' do
    before { @course.price = -1 }

    it { should_not be_valid }
  end
end
