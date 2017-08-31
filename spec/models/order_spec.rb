require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    @user = FactoryGirl.create(:user)
    @first_course = FactoryGirl.create(:course, course_type: 'first')
    @first_course.weekday_menus.create(weekday: to_weekday(Date.today))
    @main_course = FactoryGirl.create(:course, course_type: 'main')
    @main_course.weekday_menus.create(weekday: to_weekday(Date.today))
    @drink = FactoryGirl.create(:course, course_type: 'drink')
    @drink.weekday_menus.create(weekday: to_weekday(Date.today))
    @order = @user.orders.build(order_date: Date.today,
                                first_course_id: @first_course.id,
                                main_course_id: @main_course.id,
                                drink_id: @drink.id)
  end

  subject { @order }

  it { should respond_to(:order_date) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it ' should equal' do
    expect(@order.user).to eq(@user)
  end
  it { should respond_to(:first_course_id) }
  it { should respond_to(:first_course) }
  it ' should equal' do
    expect(@order.first_course).to eq(@first_course)
  end
  it { should respond_to(:main_course_id) }
  it { should respond_to(:main_course) }
  it ' should equal' do
    expect(@order.main_course).to eq(@main_course)
  end
  it { should respond_to(:drink_id) }
  it { should respond_to(:drink) }
  it ' should equal' do
    expect(@order.drink).to eq(@drink)
  end
  it { should be_valid }

  describe 'when user_id is not present' do
    before { @order.user_id = nil }
    it { should_not be_valid }
  end

  describe 'when order_date is not present' do
    before { @order.order_date = nil}
    it { should_not be_valid }
  end

  describe 'when order_date is in the past' do
    before { @order.order_date = 1.day.ago}
    it { should_not be_valid }
  end

  describe 'when first_course_id is not present' do
    before { @order.first_course_id = nil }
    it { should_not be_valid }
  end

  describe 'when first_course is invalid' do
    describe ' by type field' do
      before do
        wrong_course = FactoryGirl.create(:course, course_type: 'main')
        @order.first_course_id = wrong_course.id
      end

      it { should_not be_valid }
    end

    describe ' by weekday' do
      before do
        wrong_course = FactoryGirl.create(:course, course_type: 'first')
        wrong_course.weekday_menus.create(weekday: to_weekday(1.day.ago))
        @order.first_course_id = wrong_course.id
      end

      it { should_not be_valid }
    end
  end

  describe 'when main_course_id is not present' do
    before { @order.main_course_id = nil }
    it { should_not be_valid }
  end

  describe 'when main_course have invalid course_type' do
    describe ' by type field' do
      before do
        wrong_course = FactoryGirl.create(:course, course_type: 'drink')
        @order.main_course_id = wrong_course.id
      end

      it { should_not be_valid }
    end

    describe ' by weekday' do
      before do
        wrong_course = FactoryGirl.create(:course, course_type: 'main')
        wrong_course.weekday_menus.create(weekday: to_weekday(1.day.ago))
        @order.main_course_id = wrong_course.id
      end

      it { should_not be_valid }
    end
  end

  describe 'when drink_id is not present' do
    before { @order.drink_id = nil }
    it { should_not be_valid }
  end

  describe 'when drink have invalid course_type' do
    describe ' by type field' do
      before do
        wrong_course = FactoryGirl.create(:course, course_type: 'first')
        @order.drink_id = wrong_course.id
      end

      it { should_not be_valid }
    end

    describe ' by weekday' do
      before do
        wrong_course = FactoryGirl.create(:course, course_type: 'drink')
        wrong_course.weekday_menus.create(weekday: to_weekday(1.day.ago))
        @order.drink_id = wrong_course.id
      end

      it { should_not be_valid }
    end
  end

  it 'should have correct total price' do
    expect(@order.total_price).to eq(@first_course.price + @main_course.price + @drink.price)
  end
end
