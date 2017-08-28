namespace :db do
  task populate: :environment do
    50.times do
      title       = Faker::Beer.name
      course_type = %w[first main drink].sample
      price       = rand 300
      Course.create!(title: title,
                     course_type: course_type,
                     price: price)
    end
    Course.find_each do |c|
      c.weekday_menus.create!(weekday: %w[monday tuesday wednesday thursday friday].sample)
    end
  end
end