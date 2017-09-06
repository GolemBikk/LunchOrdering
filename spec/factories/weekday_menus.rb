FactoryGirl.define do
  factory :weekday_menu do
    weekday { Date.today.beginning_of_week + 7 }
    course
  end
end
