FactoryGirl.define do
  factory :weekday_menu do
    weekday { WeekdayMenu.weekdays.sample }
    course
  end
end
