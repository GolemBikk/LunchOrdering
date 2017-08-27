FactoryGirl.define do
  factory :course do
    sequence(:title) { |n| "Course #{n}" }
    course_type { %w[first main drink].sample }
    price { rand(300) }
  end
end
