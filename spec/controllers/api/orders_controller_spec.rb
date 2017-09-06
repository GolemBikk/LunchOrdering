require 'rails_helper'

describe Api::V1::OrdersController, type: :request do
  subject { response }

  context 'GET index' do
    context 'when user unauthorized' do
      before { get('/api/v1/orders') }

      it { expect(response.status).to(eq(401)) }
      it { expect(response.body).to(eq('User unauthorized')) }
    end

    context 'when user authorized' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        first_course = FactoryGirl.create(:course, course_type: 'first')
        main_course = FactoryGirl.create(:course, course_type: 'main')
        drink = FactoryGirl.create(:course, course_type: 'drink')
        Course.find_each do |course|
          course.weekday_menus.create(weekday: 'monday')
        end
        user.orders.create(order_date: next_week_beginning, first_course_id: first_course.id,
                           main_course_id: main_course.id, drink_id: drink.id)
        get('/api/v1/orders', params: { date: next_week_beginning,
                                        authentication_token: user.authentication_token})
      end

      it { expect(response.status).to(eq(200)) }
      it { expect(json[0]['id']).to(eq(Order.first.id)) }
    end
  end
end