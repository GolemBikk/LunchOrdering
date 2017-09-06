FactoryGirl.define do
  factory :order do
    order_date Date.today.beginning_of_week + 7
    user
  end
end
