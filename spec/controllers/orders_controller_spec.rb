require 'rails_helper'

describe OrdersController, type: :controller do
  subject { response }

  context 'GET new' do
    context 'when user unauthorized' do
      before { get(:new) }

      it { is_expected.to(redirect_to(new_user_session_path)) }
    end

    context 'when user authorized' do
      let(:invalid_weekday) { 'sunday' }
      let(:weekday) { 'monday' }
      let(:user) { FactoryGirl.create(:user) }

      before { sign_in(user) }

      context 'with invalid weekday' do
        before { get(:new, params: { weekday: invalid_weekday }) }

        it { is_expected.to(redirect_to(home_path)) }
      end

      context 'with valid weekday' do
        before do
          10.times { FactoryGirl.create(:course) }
          Course.find_each do |course|
            FactoryGirl.create(:weekday_menu, weekday: weekday, course: course)
          end
          get(:new, params: { weekday: weekday })
        end

        let(:courses) { Course.all }
        let(:order) { FactoryGirl.build(:order, order_date: to_date(weekday), user: user) }

        it { is_expected.to render_template(:new) }
        it 'assigns courses' do
          expect(assigns(:courses).map { |course| course.id }).to eq(courses.ids)
        end
        it 'assigns order' do
          expect(assigns('order').order_date).to eql(order.order_date)
          expect(assigns('order').user_id).to eql(order.user_id)
        end
      end
    end
  end

  context 'POST create' do
    let(:weekday) { 'monday' }

    context 'when user unauthorized' do
      before { post(:create) }

      it { is_expected.to(redirect_to(new_user_session_path)) }
    end

    context 'when user authorized' do
      let(:user) { FactoryGirl.create(:user) }
      let(:order_hash) { { user_id: user.id, order_date: next_week_beginning } }

      before { sign_in(user) }

      context 'without courses parameters' do
        before { post(:create, params: { order: order_hash }) }

        it { expect(Order.find_by(order_hash)).to(eq(nil)) }
        it { is_expected.to(redirect_to(new_order_path(weekday: weekday))) }
      end

      context 'with valid parameters' do
        let!(:first_course) { FactoryGirl.create(:course, course_type: 'first') }
        let!(:main_course) { FactoryGirl.create(:course, course_type: 'main') }
        let!(:drink) { FactoryGirl.create(:course, course_type: 'drink') }
        let(:order_hash) { { user_id: user.id, order_date: next_week_beginning,
                             first_course_id: first_course.id, main_course_id: main_course.id,
                             drink_id: drink.id } }
        before do
          Course.find_each do |course|
            FactoryGirl.create(:weekday_menu, weekday: weekday, course: course)
          end
          post(:create, params: { order: order_hash })
        end

        it { expect(Order.find_by(order_hash)).not_to(eq(nil)) }
        it { is_expected.to(redirect_to(home_path)) }
      end
    end
  end
end