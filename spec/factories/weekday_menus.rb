FactoryGirl.define do
  factory :weekday_menu do
    weekday { %w[monday tuesday wednesday thursday friday].sample }
    course
  end
end
